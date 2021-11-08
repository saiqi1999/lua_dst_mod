name = "server log"
description = "keep track with team"
author = "alapaka"
version = "2.0.0"
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
        name = "stack",
        label = "自动堆叠(Stacking)",
        options =
        {
            {description = "开", data = true, hover = [[掉落相同的物品会 boom 的一声堆叠起来。
            Auto stack the same loots.]]},
            {description = "关", data = false, hover = "啥事儿都不发生。Nothing will happen."},
        },
        default = false,
    },
    {
        name = "clean",
        label = "自动清理(Cleaning)",
        options =
        {
            {description = "开", data = true, hover = [[每过 10 天自动清理服务器无用物品。
            All servers clean every 10 days]]},
            {description = "关", data = false, hover = "啥事儿都不发生。Nothing will happen."},
        },
        default = false,
    },
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
						{description = "Announce横幅公告", data = 1, hover = ""},
                        {description = "System Message聊天栏", data = 2, hover = ""},
                        {description = "host only仅管理可见", data = 3, hover = ""},
                        {description = "None无", data = 0, hover = ""},
					},
		default = 3,
	},
}