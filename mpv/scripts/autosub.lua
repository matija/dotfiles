local utils = require 'mp.utils'
function load_sub_fn()
    subl = "/usr/local/bin/subliminal"
    mp.msg.info("Searching subtitle")
    mp.osd_message("Searching subtitle")
    t = {}
    t.args = {subl, "download", "-l", "en", mp.get_property("path")}
    res = utils.subprocess(t)
    print(res)
    if res.status == 0 then
        mp.commandv("rescan_external_files", "reselect")
        mp.msg.info("Subtitle download succeeded")
        mp.osd_message("Subtitle download succeeded")
    else
        mp.msg.warn("Subtitle download failed")
        mp.osd_message("Subtitle download failed")
    end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)

