local U = {}

local dota2team = {

	[1] = {
		['name'] = "Navi TI1";
		['alias'] = "Na'Vi";
		['players'] = {
			'Artstyle.Darer',
			'Puppey',
			'Dendi',
			'LightToHeaveN',
			'XBOCT'
		};
		['sponsorship'] = '';
	},
	[2] = {
		['name'] = "Ehome TI1";
		['alias'] = "EH.GIGABYTE";
		['players'] = {
			'820',
			'357',
			'FCB',
			'PLT',
			'X!!'
		};
		['sponsorship'] = 'CN';
	},
	[3] = {
		['name'] = "IG TI2";
		['alias'] = "iG";
		['players'] = {
			'Zhou',
			'Ferrari_430',
			'YYF',
			'ChuaN',
			'Faith'
		};
		['sponsorship'] = '';
	},
	[4] = {
		['name'] = "Navi TI2";
		['alias'] = "Na'Vi";
		['players'] = {
			'XBOCT',
			'Dendi',
			'LightToHeaveN',
			'Puppey',
			'ARS-ART'
		};
		['sponsorship'] = '';
	},
	[5] = {
		['name'] = "Alliance TI3";
		['alias'] = "";
		['players'] = {
			'Lod[A]',
			'[A]s4',
			'[A]dmiralBulldog',
			'[A]EGM',
			'[A]kke'
		};
		['sponsorship'] = '';
	},
	[6] = {
		['name'] = "Navi TI3";
		['alias'] = "Na'Vi";
		['players'] = {
			'XBOCT',
			'Dendi',
			'Funn1k',
			'Puppey',
			'KuroKy'
		};
		['sponsorship'] = '';
	},
	[7] = {
		['name'] = "Newbee TI4";
		['alias'] = "Newbee";
		['players'] = {
			'Hao',
			'Mu',
			'xiao8',
			'Banana',
			'SanSheng'
		};
		['sponsorship'] = '';
	},
	[8] = {
		['name'] = "VG TI4";
		['alias'] = "VG";
		['players'] = {
			'Sylar',
			'Super',
			'rOtk',
			'fy',
			'Fenrir'
		};
		['sponsorship'] = '天喔';
	},
	[9] = {
		['name'] = "Evil Geniuses TI5";
		['alias'] = "EG";
		['players'] = {
			'Fear',
			'SumaiL.Coffin',
			'UNiVeRsE',
			'Aui_2000',
			'ppd'
		};
		['sponsorship'] = '';
	},
	[10] = {
		['name'] = "CDEC Gaming TI5";
		['alias'] = "CDEC";
		['players'] = {
			'Q',
			'Xz',
			'garder',
			'Shiki',
			'Agressif'
		};
		['sponsorship'] = 'DouYuTV';
	},
	[11] = {
		['name'] = "Wings Gaming TI6";
		['alias'] = "Wings";
		['players'] = {
			'shadow',
			'跳刀跳刀丶.bLink',
			'Faith_bian.Vicky',
			'y`.innocence',
			'iceice'
		};
		['sponsorship'] = '';
	},
	[12] = {
		['name'] = "Digital Chaos TI6";
		['alias'] = "DC";
		['players'] = {
			'Resolut1on',
			'w33',
			'Moo.hotaW',
			'MiSeRy',
			'Saksa'
		};
		['sponsorship'] = '';
	},
	[13] = {
		['name'] = "Team Liquid TI7";
		['alias'] = "Liquid";
		['players'] = {
			'MATUMBAMAN',
			'Miracle-',
			'MinD_ContRoL',
			'GH',
			'KuroKy'
		};
		['sponsorship'] = '';
	},
	[14] = {
		['name'] = "Newbee TI7";
		['alias'] = "Newbee";
		['players'] = {
			'Moogy',
			'Sccc',
			'kpii',
			'Kaka',
			'Faith'
		};
		['sponsorship'] = '';
	},
}

local sponsorship = {"GG.bet", "gg.bet", "VPGAME", "LOOT.bet", "loot.bet", "", "Esports.bet", "G2A", "Dota2.net"};

function U.GetDota2Team()
	local bot_names = {};
	local rand = RandomInt(1, #dota2team); 
	local srand = RandomInt(1, #sponsorship); 
	if GetTeam() == TEAM_RADIANT then
		while rand%2 ~= 0 do
			rand = RandomInt(1, #dota2team); 
		end
	else
		while rand%2 ~= 1 do
			rand = RandomInt(1, #dota2team); 
		end
	end
	local team = dota2team[rand];
	for _,player in pairs(team.players) do
		if team.sponsorship == "" then
			table.insert(bot_names, team.alias.."."..player);
		else
			table.insert(bot_names, team.alias.."."..player.."."..team.sponsorship);
		end
	end
	return bot_names;
end

return U