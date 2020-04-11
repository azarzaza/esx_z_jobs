Config.Jobs.slaughterer = {

	BlipInfos = {
		Sprite = 256,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "benson",
			Trailer = "none",
			HasCaution = true
		}
	},

	Zones = {

		CloakRoom = {
			Pos = {x = -1071.13, y = -2003.78, z = 14.78},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("s_slaughter_locker"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			Item = {
				fromHour = 9,
				toHour = 18
			}
		},

		AliveChicken = {
			Pos = {x = 1855.84, y = 4991.11, z = 52.43},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("s_hen"),
			Type = "farm",
			Props = "a_c_hen",
			PropsType = "ped",
			Animation = "PROP_HUMAN_BUM_BIN",
			label = _U('s_pickupprompt'),
			Item = {
				name = _U("s_alive_chicken"),
				db_name = "alive_chicken",
				time = 10000,
				max = 20,
				add = 1,
				remove = 1,
				requires = "nothing",
				requires_name = "Nothing",
				drop = 100,
				spawnLimit = 8,
				fromHour = 8,
				toHour = 16
			},
			Hint = _U("s_catch_hen")
		},

		SlaughterHouse = {
			Pos = {x = -77.99, y = 6229.06, z = 30.09},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("s_slaughtered"),
			Type = "work",
			Item = {
				name = _U("s_slaughtered_chicken"),
				db_name = "slaughtered_chicken",
				time = 5000,
				max = 20,
				add = 1,
				remove = 1,
				requires = "alive_chicken",
				requires_name = _U("s_alive_chicken"),
				drop = 100,
				fromHour = 8,
				toHour = 16
			},
			Hint = _U("s_chop_animal")
		},

		Packaging = {
			Pos = {x = -101.97, y = 6208.79, z = 30.02},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("s_package"),
			Type = "work",
			Item = {
				name = _U("s_packagechicken"),
				db_name = "packaged_chicken",
				time = 4000,
				max = 100,
				add = 5,
				remove = 1,
				requires = "slaughtered_chicken",
				requires_name = _U("s_unpackaged"),
				drop = 100,
				fromHour = 8,
				toHour = 16
			},
			Hint = _U("s_unpackaged_button")
		},

		Delivery = {
			Pos = {x = -596.15, y = -889.32, z = 24.50},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U("delivery_point"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				name = _U("delivery"),
				time = 5000,
				remove = 1,
				max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
				price = math.random(100,150),
				requires = "packaged_chicken",
				requires_name = _U("s_packagechicken"),
				drop = 100,
				fromHour = 8,
				toHour = 16
			},
			Hint = _U("s_deliver")
		}
	}
}
