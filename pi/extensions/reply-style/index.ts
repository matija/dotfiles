import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";

const GUIDANCE = "Keep replies concise. Start with a short bold label; bold key terms sparingly. Use [[Done]], [[Failed]], [[Blocked]], [[Needs you]], or [[Unverified]] for meaningful status only. Explain blockers and user actions. Use bullets for lists, arrows for sequences. Keep code, commands, paths, and requested exact formats free of decoration.";

type Tone = "success" | "error" | "warning" | "danger" | "mode" | "owner" | "neutral";
type Colorize = (text: string) => string;
type Palette = {
	bold: Colorize;
	pills: Record<Tone, { label: string; cap: string }>;
	marks: Record<string, Colorize>;
};

const GROUPS: Partial<Record<Tone, string[]>> = {
	error: ["Failed", "Blocked", "Broken", "Unsafe"],
	warning: ["Needs you", "Decision", "Unverified", "Partial", "Skipped", "In progress", "Pending", "At risk"],
	success: ["Done", "Passed", "Observed", "Fixed", "Live", "Recommended", "Keep"],
	danger: ["Costs money", "Destructive", "Irreversible"],
	mode: ["Brainstorm", "Investigate", "Preview", "Implement", "Qualify"],
	owner: ["Owned", "Shared", "Foreign"],
};
const TONES = new Map(Object.entries(GROUPS).flatMap(([tone, words]) => words.map(word => [word.toLowerCase(), tone as Tone] as const)));
const PILL_ICONS: Record<string, string> = {
	done: "\uf00c", passed: "\uf00c", observed: "\uf06e", fixed: "\uf0ad", live: "\uf135", recommended: "\uf005", keep: "\uf08d",
	failed: "\uf00d", blocked: "\uf05e", broken: "\uf127", unsafe: "\uf132",
	"needs you": "\uf007", decision: "\uf126", unverified: "\uf128", partial: "\uf042", skipped: "\uf04e", "in progress": "\uf110", pending: "\uf017", "at risk": "\uf071",
	"costs money": "\uf155", destructive: "\uf1f8", irreversible: "\uf023",
	brainstorm: "\uf0eb", investigate: "\uf002", preview: "\uf06e", implement: "\uf0ad", qualify: "\uf0c3",
	owned: "\uf007", shared: "\uf0c0", foreign: "\uf023", inferred: "\uf0eb", new: "\uf067", changed: "\uf040", optional: "\uf10c",
};
const LABEL_ICONS: Record<string, string> = {
	finding: "\uf002", terminal: "\uf120", folder: "\uf07b", file: "\uf15b", branch: "\uf126", review: "\uf06e",
	ideas: "\uf0eb", cause: "\uf0e7", fix: "\uf0ad", risk: "\uf071", limits: "\uf071", next: "\uf061", rollback: "\uf0e2",
	undo: "\uf0e2", options: "\uf0ca", result: "\uf11e", why: "\uf059", how: "\uf013", cost: "\uf155", rule: "\uf0e3",
	example: "\uf121", checked: "\uf00c", pills: "\uf02b", colors: "\uf1fc", icons: "\uf005", scoreboard: "\uf080",
	verdict: "\uf0e3", effect: "\uf140", evidence: "\uf06e", plan: "\uf0ae", status: "\uf012", decision: "\uf126",
};
const ACTION_ICONS: Record<string, string> = {
	check: "\uf046", do: "\uf0a4", next: "\uf061", unblock: "\uf09c", left: "\uf141", run: "\uf04b", guard: "\uf132", undo: "\uf0e2", see: "\uf08e",
};
const KNOWN = [...Object.keys(PILL_ICONS)].sort((a, b) => b.length - a.length);
const ACTION_LABEL = new RegExp(`(\\*\\*)(${Object.keys(ACTION_ICONS).join("|")})(:\\*\\*)`, "gi");
const LEAD_LABEL = /^(\s*(?:[-*+]|\d+\.)?\s*(?:[├└]──\s*)?\*\*)([^*`\n]{1,32})(\*\*)/;
const INLINE = /(\\*)(\*\*|__)|\[\[([^\[\]\n]{1,32})\]\]/g;
const FENCE = /^ {0,3}(`{3,}|~{3,})(.*)$/;

function createPalette(theme: Theme): Palette {
	const fg = (name: Parameters<Theme["fg"]>[0]): Colorize => text => theme.fg(name, text);
	const tone = (color: Parameters<Theme["fg"]>[0], background: Parameters<Theme["getBgAnsi"]>[0]) => {
		const bg = theme.getBgAnsi(background);
		const ink = theme.getFgAnsi(color);
		return !bg || bg === "\x1b[49m"
			? { label: ink + "\x1b[7m", cap: ink }
			: { label: bg + ink, cap: bg.replace(/\x1b\[48;/g, "\x1b[38;").replace(/\x1b\[(4|10)([0-7])m/g, (_, p, n) => `\x1b[${p === "4" ? "3" : "9"}${n}m`) };
	};
	const solid = (code: number) => ({ label: `\x1b[${code}m\x1b[7m`, cap: `\x1b[${code}m` });
	return {
		bold: fg("mdLink"),
		pills: {
			success: tone("success", "toolSuccessBg"), error: tone("error", "toolErrorBg"), warning: tone("warning", "searchMatchBg"),
			neutral: tone("accent", "selectedBg"), danger: solid(31), mode: solid(36), owner: solid(34),
		},
		marks: { "✓": fg("success"), "✔": fg("success"), "✗": fg("error"), "✘": fg("error"), "→": fg("accent"), "├──": fg("dim"), "└──": fg("dim") },
	};
}

function withLabelIcon(label: string): string {
	const word = label.replace(/[:\s]+$/, "").trim().toLowerCase();
	const icon = LABEL_ICONS[word] ?? (label.trimEnd().endsWith(":") ? ACTION_ICONS[word] : undefined);
	return icon ? `${icon} ${label}` : label;
}

function pill(label: string, palette: Palette): string {
	const word = label.replace(/\s+/g, " ").trim();
	const lower = word.toLowerCase();
	const key = KNOWN.find(k => lower === k || (lower.startsWith(k) && /[ :]/.test(lower[k.length]))) ?? lower;
	const style = palette.pills[TONES.get(key) ?? "neutral"];
	const icon = PILL_ICONS[key];
	const text = (icon ? `${icon} ${word}` : word).replace(/ /g, "\u00a0");
	return `${style.cap}\ue0b6\x1b[39m${style.label}\x1b[1m${text}\x1b[22;27m\x1b[39;49m${style.cap}\ue0b4\x1b[39m`;
}

function decorateLine(line: string, palette: Palette, open: string, close: string): string {
	const parts = line.replace(LEAD_LABEL, (_, before, label, after) => before + withLabelIcon(label) + after).split(/(`+[^`]*?`+)/g);
	let result = "";
	let inBold: string | undefined;
	for (let i = 0; i < parts.length; i++) {
		if (i % 2 === 1) {
			result += parts[i] + (inBold ? open : "");
			continue;
		}
		const prose = parts[i]
			.replace(ACTION_LABEL, (_, before, word, after) => `${before}${ACTION_ICONS[word.toLowerCase()]} ${word}${after}`)
			.replace(/✓|✔|✗|✘|→|[├└]──/g, mark => palette.marks[mark](mark) + (inBold ? open : ""));
		result += prose.replace(INLINE, (match, slashes, marker, label) => {
			if (label !== undefined) return label.trim() ? pill(label, palette) + (inBold ? `\x1b[1m${open}` : "") : match;
			if ((slashes ?? "").length % 2 === 1) return match;
			if (!inBold) {
				inBold = marker;
				return `${slashes}${marker}${open}`;
			}
			if (inBold === marker) {
				inBold = undefined;
				return `${slashes}${close}${marker}`;
			}
			return match;
		});
	}
	return result + (inBold ? close : "");
}

function decorate(markdown: string, palette: Palette): string {
	const [open, close] = palette.bold("\u0000").split("\u0000");
	let fence: string | undefined;
	return markdown.split("\n").map(line => {
		const match = line.match(FENCE);
		if (fence) {
			if (match && match[1][0] === fence[0] && match[1].length >= fence.length && !match[2].trim()) fence = undefined;
			return line;
		}
		if (match) {
			fence = match[1];
			return line;
		}
		if (/^ {0,3}#{1,6}\s/.test(line)) return line.replace(/^( {0,3}#{1,6}\s+)(.+)$/, (_, hashes, title) => hashes + withLabelIcon(title));
		return decorateLine(line, palette, open, close);
	}).join("\n");
}

export default function replyStyle(pi: ExtensionAPI) {
	let currentTheme: (() => Theme) | undefined;
	let built: { colors: Theme["colors"]; palette: Palette } | undefined;
	pi.on("session_start", (_event, ctx) => {
		currentTheme = ctx.mode === "tui" ? () => ctx.ui.theme : undefined;
	});
	pi.on("before_agent_start", (event, ctx) => {
		if (ctx.mode === "tui") (event.systemPromptOptions.sections ??= {}).reply_style = GUIDANCE;
	});
	pi.registerMarkdownTransformer(markdown => {
		if (!currentTheme) return markdown;
		const theme = currentTheme();
		if (built?.colors !== theme.colors) built = { colors: theme.colors, palette: createPalette(theme) };
		return decorate(markdown, built.palette);
	}, { messageTypes: ["assistant"] });
}
