name = "Breaking Warning Admin only"
description = "what are others doing?"
author = "alapaka"
version = "2.1.4"
forumthread = ""
priority = -1000
api_version = 10

dst_compatible = true

icon_atlas = "Nomodicon.xml"
icon = "Nomodicon.tex"

client_only_mod = false
all_clients_require_mod = true
server_filter_tags = {"stack", "clean"}

----------------------
-- General settings --
----------------------

configuration_options =
{
    {
        name = "lang",
        label = "语言(Language)",
        options =
        {
            {description = "中文", data = true},
            {description = "English", data = false},
        },
        default = false,
    },
	{
		name = "notice_method",
		label = "Notice Method",
		hover = "",
		options =	{
						{description = "Announce横幅公告(没必要吧", data = 1, hover = ""},
                        {description = "System Message聊天栏", data = 2, hover = ""},
                        {description = "Admin only仅管理可见", data = 3, hover = ""},
                        {description = "None无", data = 0, hover = ""},
					},
		default = 3,
	},
    {
        name = "notice_pos",
        label = "show notice position",
        options = {
            {description = "left", data = 1},
            {description = "right", data = 2},
        },
        default = 1,
    },
}