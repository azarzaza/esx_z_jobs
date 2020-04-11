Config.Jobs.tailor = {

	BlipInfos = {
		Sprite = 366,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "youga2",
			Trailer = "none",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 706.73, y = -960.90, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_dress_locker"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			GPS = {x = 740.80, y = -970.06, z = 23.46},
			Item = {
				fromHour = 9,
				toHour = 18
			}
		},

		Wool = {
			Pos = {x = 1928.85, y = 4967.91, z = 44.35},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_wool"),
			Type = "farm",
			Props = "a_c_deer",
			PropsType = "ped",
			label =  _U('dd_pickupprompt'),
			Animation = "PROP_HUMAN_BUM_BIN",
			Item = {
				name = _U("dd_wool"),
				db_name = "wool",
				time = 8000,
				max = 100,
				add = 1,
				remove = 1,
				requires = "nothing",
				requires_name = "Nothing",
				drop = 100,
				spawnLimit = 5,
				fromHour = 9,
				toHour = 18
			},
			Hint = _U("dd_pickup"),
			GPS = {x = 715.95, y = -959.63, z = 29.39}
		},

		Fabric = {
			Pos = {x = 715.95, y = -959.63, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("dd_fabric"),
			Type = "work",
			Item = {
				name = _U("dd_fabric"),
				db_name = "fabric",
				time = 5000,
				max = 100,
				add = 2,
				remove = 1,
				requires = "wool",
				requires_name = _U("dd_wool"),
				drop = 100,
				fromHour = 9,
				toHour = 18
			},
			Hint = _U("dd_makefabric"),
			GPS = {x = 712.92, y = -970.58, z = 29.39}
		},

		Clothe = {
			Pos = {x = 712.92, y = -970.58, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("dd_clothing"),
			Type = "work",
			Item = {
				{
					name = _U("dd_clothing"),
					db_name = "clothe",
					time = 4000,
					max = 100,
					add = 1,
					remove = 2,
					requires = "fabric",
					requires_name = _U("dd_fabric"),
					drop = 100,
					fromHour = 9,
					toHour = 18
				}
			},
			Hint = _U("dd_makeclothing"),
			GPS = {x = 429.59, y = -807.34, z = 28.49}
		},

		Delivery = {
			Pos = {x = 429.59, y = -807.34, z = 28.49},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U("delivery_point"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				{
					name = _U("delivery"),
					time = 10000,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = math.random(60,100),
					requires = "clothe",
					requires_name = _U("dd_clothing"),
					drop = 100,
					fromHour = 9,
					toHour = 18
				}
			},
			Hint = _U("dd_deliver_clothes"),
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		}
	}
}
