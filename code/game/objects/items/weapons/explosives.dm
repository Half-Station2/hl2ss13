/obj/item/weapon/plastique/attack_self(mob/user)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(newtime < 10)
		newtime = 10
	timer = newtime
	to_chat(user, "Timer set for [timer] seconds.")

/obj/item/weapon/plastique/afterattack(atom/target, mob/user, flag)
	if (!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage/) || istype(target, /obj/machinery/nuclearbomb))
		return
	to_chat(user, "Planting explosives...")
	if(ismob(target))

		user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] tried planting [name] on [target:real_name] ([target:ckey])</font>"
		msg_admin_attack("[user.real_name] ([user.ckey]) tried planting [name] on [target:real_name] ([target:ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		user.visible_message("\red [user.name] is trying to plant some kind of explosive on [target.name]!")

	if(do_after(user, 50, target = target) && in_range(user, target))
		user.drop_item()
		target = target
		loc = null
		var/location
		if (isturf(target)) location = target
		if (isobj(target)) location = target.loc
		if (ismob(target))
			target:attack_log += "\[[time_stamp()]\]<font color='orange'> Had the [name] planted on them by [user.real_name] ([user.ckey])</font>"
			user.visible_message("\red [user.name] finished planting an explosive on [target.name]!")
		target.overlays += image('icons/obj/assemblies.dmi', "plastic-explosive2")
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		spawn(timer*10)
			if(target)
				if(ismob(target)) location = target.loc
				explosion(location, 0, 0, 2, 3)
				if (istype(target, /turf/simulated/wall)) target:dismantle_wall(1)
				else target.ex_act(1)
				if (isobj(target))
					if (target)
						qdel(target)
				if (src)
					qdel(src)

/obj/item/weapon/plastique/attack(mob/M, mob/user, def_zone)
	return