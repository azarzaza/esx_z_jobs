Config.Jobs.lumberjack = {

	BlipInfos = {
		Sprite = 237,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "phantom",
			Trailer = "trailers",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 1200.63, y = -1276.87, z = 34.38},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("lj_locker_room"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			Item = {
				fromHour = 9,
				toHour = 18
			}
		},

		Wood = {
			Pos = {x =  -576.83, y = 5449.66, z = 60.59},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("lj_mapblip"),
			Type = "farm",
			Props = "prop_log_02",
			Animation = "world_human_gardener_plant",
			label = _U('lj_pickupprompt'),
			PropsType = "object",
			Item = {
				name = _U("lj_wood"),
				db_name = "wood",
				time = 3000,
				max = 20,
				add = 1,
				remove = 1,
				requires = "nothing",
				requires_name = "Nothing",
				drop = 100,
				spawnLimit = 5,
				fromHour = 12,
				toHour = 20
			},
			Hint = _U("lj_pickup")
		},

		CuttedWood = {
			Pos = {x = -552.21, y = 5326.90, z = 72.59},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("lj_cutwood"),
			Type = "work",
			Item = {
				name = _U("lj_cutwood"),
				db_name = "cutted_wood",
				time = 5000,
				max = 20,
				add = 1,
				remove = 1,
				requires = "wood",
				requires_name = _U("lj_wood"),
				drop = 100,
				fromHour = 12,
				toHour = 20
			},
			Hint = _U("lj_cutwood_button")
		},

		Planks = {
			Pos = {x = -501.38, y = 5280.53, z = 79.61},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("lj_board"),
			Type = "work",
			Item = {
				name = _U("lj_planks"),
				db_name = "packaged_plank",
				time = 4000,
				max = 100,
				add = 5,
				remove = 1,
				requires = "cutted_wood",
				requires_name = _U("lj_cutwood"),
				drop = 100,
				fromHour = 12,
				toHour = 20
			},
			Hint = _U("lj_pick_boards")
		},
		Delivery = {
			Pos = {x = 1201.35, y = -1327.51, z = 34.22},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U("delivery_point"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				name = _U("delivery"),
				time = 5000,
				remove = 1,
				max = 50, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
				price =  math.random(50,90),
				requires = "packaged_plank",
				requires_name = _U("lj_planks"),
				drop = 100,
				fromHour = 12,
				toHour = 20
			},
			Hint = _U("lj_deliver_button")
		}
	}
}
