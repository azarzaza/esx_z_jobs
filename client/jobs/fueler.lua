Config.Jobs.fueler = {

	BlipInfos = {
		Sprite = 436,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "phantom",
			Trailer = "tanker",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 557.93, y = -2327.90, z = 4.82},
			Size = {x = 3.0, y = 3.0, z = 2.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("f_oil_refiner"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			GPS = {x = 554.59, y = -2314.43, z = 4.86},
			IsLicense = true,
			License = {
				name = "fueler_job",
				price = 2000,
				label = _U("f_license")
			},
			Item = {
				fromHour = 9,
				toHour = 18
			}
		},

		OilFarm = {
			Pos = {x = 613.58, y = 2863.74, z = 38.90},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("f_drill_oil"),
			Type = "farm",
			Props = "prop_barrel_exp_01a",
			Animation = "PROP_HUMAN_BUM_BIN",
			label = _U('f_pickupprompt'),
			PropsType = "object",
			Item = {
					name = _U("f_fuel"),
					db_name = "petrol",
					time = 5000,
					max = 20,
					add = 1,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100,
					spawnLimit = 5,
					fromHour = 9,
					toHour = 18
			},
			Hint = _U("f_drillbutton"),
			GPS = {x = 2736.94, y = 1417.99, z = 23.48}
		},

		OilRefinement = {
			Pos = {x = 2736.94, y = 1417.99, z = 23.48},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("f_fuel_refine"),
			Type = "work",
			Item = {
				name = _U("f_fuel_refine"),
				db_name = "petrol_raffin",
				time = 5000,
				max = 200,
				add = 1,
				remove = 2,
				requires = "petrol",
				requires_name = _U("f_fuel"),
				drop = 100,
				fromHour = 9,
				toHour = 18
			},
			Hint = _U("f_refine_fuel_button"),
			GPS = {x = 265.75, y = -3013.39, z = 4.73}
		},

		OilMix = {
			Pos = {x = 265.75, y = -3013.39, z = 4.73},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("f_fuel_mixture"),
			Type = "work",
			Item = {
				name = _U("f_gas"),
				db_name = "essence",
				time = 5000,
				max = 200,
				add = 2,
				remove = 1,
				requires = "petrol_raffin",
				requires_name = _U("f_fuel_refine"),
				drop = 100,
				fromHour = 9,
				toHour = 18
			},
			Hint = _U("f_fuel_mixture_button"),
			GPS = {x = 491.40, y = -2163.37, z = 4.91}
		},

		Delivery = {
			Pos = {x = 491.40, y = -2163.37, z = 4.91},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U("f_deliver_gas"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				name = _U("delivery"),
				time = 5000,
				remove = 1,
				max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
				price = math.random(50,100),
				requires = "essence",
				requires_name = _U("f_gas"),
				drop = 100,
				fromHour = 9,
				toHour = 18
			},
			Hint = _U("f_deliver_gas_button"),
			GPS = {x = 609.58, y = 2856.74, z = 39.49}
		}

	}
}
