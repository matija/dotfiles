import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

export default function () {
  if (process.env.TYPESAFE_API_KEY) return;
  const auth = JSON.parse(readFileSync(join(homedir(), ".pi", "agent", "auth.json"), "utf8"));
  if (auth.typesafe?.type === "api_key" && typeof auth.typesafe.key === "string")
    process.env.TYPESAFE_API_KEY = auth.typesafe.key;
}
