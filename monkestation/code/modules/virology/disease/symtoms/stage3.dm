GLOBAL_LIST_INIT(disease_hivemind_users, list())


/datum/symptom/toxins
	name = "Hyperacidity"
	desc = "Inhibits the infected's ability to process natural toxins, producing a buildup of said toxins."
	stage = 3
	max_multiplier = 3
	badness = EFFECT_DANGER_HARMFUL

/datum/symptom/toxins/activate(mob/living/carbon/mob)
	mob.adjustToxLoss((2*multiplier))


/datum/symptom/shakey
	name = "World Shaking Syndrome"
	desc = "Attacks the infected's motor output, giving them a sense of vertigo."
	stage = 3
	max_multiplier = 3
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/shakey/activate(mob/living/carbon/mob)
	shake_camera(mob, 5*multiplier)


/datum/symptom/telepathic
	name = "Abductor Syndrome"
	desc = "Repurposes a portion of the users brain, making them incapable of normal speech but allows you to talk into a hivemind."
	stage = 3
	max_count = 1
	badness = EFFECT_DANGER_FLAVOR

/datum/symptom/telepathic/first_activate(mob/living/carbon/mob)
	GLOB.disease_hivemind_users |= mob
	RegisterSignal(mob, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/symptom/telepathic/deactivate(mob/living/carbon/mob)
	GLOB.disease_hivemind_users -= mob
	UnregisterSignal(mob, COMSIG_MOB_SAY)

/datum/symptom/telepathic/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/mob = source
	mob.log_talk(message, LOG_SAY, tag="HIVEMIND DISEASE")
	for(var/mob/living/living as anything in GLOB.disease_hivemind_users)
		if(!isliving(living))
			continue
		to_chat(living, span_abductor("<b>[mob.real_name]:</b>[message]"))

	for(var/mob/dead_mob in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(dead_mob, mob)
		to_chat(dead_mob, "<b>[mob.real_name][link]:</b>[message]")

	speech_args[SPEECH_MESSAGE] = "" //yep we dont speak anymore

/datum/symptom/mind
	name = "Lazy Mind Syndrome"
	desc = "Rots the infected's brain."
	stage = 3
	badness = EFFECT_DANGER_HARMFUL

/datum/symptom/mind/activate(mob/living/carbon/mob)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 50)
	else
		mob.setCloneLoss(50)

/datum/symptom/hallucinations
	name = "Hallucinational Syndrome"
	desc = "Induces hallucination in the infected."
	stage = 3
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/hallucinations/activate(mob/living/carbon/mob)
	mob.adjust_hallucinations(5 SECONDS)

/datum/symptom/giggle
	name = "Uncontrolled Laughter Effect"
	desc = "Gives the infected a sense of humor."
	stage = 3
	badness = EFFECT_DANGER_FLAVOR

/datum/symptom/giggle/activate(mob/living/carbon/mob)
	mob.emote("giggle")

/datum/symptom/chickenpox
	name = "Chicken Pox"
	desc = "Causes the infected to begin coughing up eggs of the poultry variety."
	stage = 3
	badness = EFFECT_DANGER_ANNOYING
	var/eggspawn = /obj/item/food/egg

/datum/symptom/chickenpox/activate(mob/living/carbon/mob)
	if (prob(30))
		mob.say(pick("BAWWWK!", "BAAAWWK!", "CLUCK!", "CLUUUCK!", "BAAAAWWWK!"))
	if (prob(15))
		mob.emote("me",1,"vomits up a chicken egg!")
		playsound(mob.loc, 'sound/effects/splat.ogg', 50, 1)
		new eggspawn(get_turf(mob))

/datum/symptom/confusion
	name = "Topographical Cretinism"
	desc = "Attacks the infected's ability to differentiate left and right."
	stage = 3
	badness = EFFECT_DANGER_HINDRANCE
	max_multiplier = 5
	max_chance = 15

/datum/symptom/confusion/activate(mob/living/carbon/mob)
	to_chat(mob, span_notice("You have trouble telling right and left apart all of a sudden."))
	mob.adjust_confusion(1 SECONDS * multiplier)

/datum/symptom/groan
	name = "Groaning Syndrome"
	desc = "Causes the infected to groan randomly."
	stage = 3
	badness = EFFECT_DANGER_FLAVOR

/datum/symptom/groan/activate(mob/living/carbon/mob)
	mob.emote("groan")


/datum/symptom/sweat
	name = "Hyper-perspiration Effect"
	desc = "Causes the infected's sweat glands to go into overdrive."
	stage = 3
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/sweat/activate(mob/living/carbon/mob)
	if(prob(30))
		mob.emote("me",1,"is sweating profusely!")

		if(istype(mob.loc,/turf/open))
			var/turf/open/turf = mob.loc
			turf.add_liquid_list(list(/datum/reagent/water = 20), TRUE)

/datum/symptom/elvis
	name = "Elvisism"
	desc = "Makes the infected the king of rock and roll."
	stage = 3
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/elvis/first_activate(mob/living/carbon/mob)
	if(ismouse(mob))
		var/mob/living/basic/mouse/mouse = mob
		mouse.icon_state = "mouse_elvis"
		mouse.base_icon_state = "mouse_elvis"
		mouse.icon_living = "mouse_elvis"
		mouse.icon_dead = "mouse_brown_dead"
		return
	mob.dna.add_mutation(/datum/mutation/human/elvis, MUT_EXTRA)

/datum/symptom/elvis/activate(mob/living/carbon/mob)
	if(!ishuman(mob))
		return

	var/mob/living/carbon/human/victim = mob

	/*
	var/obj/item/clothing/glasses/H_glasses = H.get_item_by_slot(slot_glasses)
	if(!istype(H_glasses, /obj/item/clothing/glasses/sunglasses/virus))
		var/obj/item/clothing/glasses/sunglasses/virus/virussunglasses = new
		mob.u_equip(H_glasses,1)
		mob.equip_to_slot(virussunglasses, slot_glasses)
	*/

	mob.adjust_confusion(1 SECONDS)

	if(prob(50))
		mob.say(pick("Uh HUH!", "Thank you, Thank you very much...", "I ain't nothin' but a hound dog!", "Swing low, sweet chariot!"))
	else
		mob.emote("me",1,pick("curls his lip!", "gyrates his hips!", "thrusts his hips!"))

	if(istype(victim))

		if(!(victim.hairstyle == "Pompadour (Big)"))
			spawn(50)
				victim.hairstyle = "Pompadour (Big)"
				victim.hair_color = "#242424"
				victim.update_body()

		if(!(victim.facial_hairstyle == "Sideburns (Elvis)"))
			spawn(50)
				victim.facial_hairstyle = "Sideburns (Elvis)"
				victim.facial_hair_color = "#242424"
				victim.update_body()

/datum/symptom/elvis/deactivate(mob/living/carbon/mob)
	if(ismouse(mob))
		return
	/*
	if(ishuman(mob))
		var/mob/living/carbon/human/dude = mob
		if(istype(dude.glasses, /obj/item/clothing/glasses/sunglasses/virus))
			dude.glasses.canremove = 1
			dude.u_equip(dude.glasses,1)
	*/
	mob.dna.remove_mutation(/datum/mutation/human/elvis)

/datum/symptom/pthroat
	name = "Pierrot's Throat"
	desc = "Overinduces a sense of humor in the infected, causing them to be overcome by the spirit of a clown."
	stage = 3
	max_multiplier = 4
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/pthroat/activate(mob/living/carbon/mob)
	if(ismouse(mob))
		var/mob/living/basic/mouse/mouse = mob
		mouse.icon_state = "mouse_clown"
		mouse.icon_living = "mouse_clown"
		mouse.icon_dead = "mouse_clown_dead"
		mouse.held_state = "mouse_clown"

	mob.say(pick("HONK!", "Honk!", "Honk.", "Honk?", "Honk!!", "Honk?!", "Honk..."))
	if(ishuman(mob))
		var/mob/living/carbon/human/affected = mob
		if(multiplier >=2) //clown mask added
			var/obj/item/clothing/mask/gas/clown_hat/virus/virusclown_hat = new /obj/item/clothing/mask/gas/clown_hat/virus
			if(affected.wear_mask && !istype(affected.wear_mask, /obj/item/clothing/mask/gas/clown_hat/virus))
				affected.dropItemToGround(mob.wear_mask, TRUE)
				affected.equip_to_slot(virusclown_hat, ITEM_SLOT_MASK)
			if(!affected.wear_mask)
				affected.equip_to_slot(virusclown_hat, ITEM_SLOT_MASK)
		if(multiplier >=3) //clown shoes added
			var/obj/item/clothing/shoes/clown_shoes/virusshoes = new /obj/item/clothing/shoes/clown_shoes
			if(affected.shoes && !istype(affected.shoes, /obj/item/clothing/shoes/clown_shoes))
				affected.dropItemToGround(affected.shoes, TRUE)
				affected.equip_to_slot(virusshoes, ITEM_SLOT_FEET)
			if(!affected.shoes)
				affected.equip_to_slot(virusshoes, ITEM_SLOT_FEET)
		if(multiplier >=4) //clown suit added
			var/obj/item/clothing/under/rank/civilian/clown/virussuit = new /obj/item/clothing/under/rank/civilian/clown
			if(affected.w_uniform && !istype(affected.w_uniform, /obj/item/clothing/under/rank/civilian/clown))
				affected.dropItemToGround(affected.w_uniform, TRUE)
				affected.equip_to_slot(virussuit, ITEM_SLOT_ICLOTHING)
			if(!affected.w_uniform)
				affected.equip_to_slot(virussuit, ITEM_SLOT_ICLOTHING)

/datum/symptom/pthroat/first_activate(mob/living/carbon/mob)
	RegisterSignal(mob, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/symptom/pthroat/deactivate(mob/living/carbon/mob)
	UnregisterSignal(mob, COMSIG_MOB_SAY)

/datum/symptom/pthroat/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	var/list/split_message = splittext(message, " ") //List each word in the message
	var/applied = 0
	for (var/i in 1 to length(split_message))
		if(prob(3 * multiplier)) //Stage 1: 3% Stage 2: 6% Stage 3: 9% Stage 4: 12%
			if(findtext(split_message[i], "*") || findtext(split_message[i], ";") || findtext(split_message[i], ":"))
				continue
			split_message[i] = "HONK"
			if (applied++ > stage)
				break
	if (applied)
		speech_args[SPEECH_SPANS] |= SPAN_CLOWN // a little bonus
	message = jointext(split_message, " ")
	speech_args[SPEECH_MESSAGE] = message

/datum/symptom/horsethroat
	name = "Horse Throat"
	desc = "Inhibits communication from the infected through spontaneous generation of a horse mask."
	stage = 3
	badness = EFFECT_DANGER_HINDRANCE

/datum/symptom/horsethroat/activate(mob/living/carbon/mob)
	if(ismouse(mob))
		var/mob/living/basic/mouse/mouse = mob
		mouse.icon_state = "mouse_horse"
		mouse.icon_living = "mouse_horse"
		mouse.icon_dead = "mouse_horse_dead"
		mouse.held_state = "mouse_horse"

	mob.say(pick("NEIGH!", "Neigh!", "Neigh.", "Neigh?", "Neigh!!", "Neigh?!", "Neigh..."))
	if(!ishuman(mob))
		return

	var/mob/living/carbon/human/human = mob
	var/obj/item/clothing/mask/animal/horsehead/magichead = new /obj/item/clothing/mask/animal/horsehead
	if(human.wear_mask && !istype(human.wear_mask,/obj/item/clothing/mask/animal/horsehead))
		human.dropItemToGround(human.wear_mask, TRUE)
		human.equip_to_slot(magichead, ITEM_SLOT_MASK)
	if(!human.wear_mask)
		human.equip_to_slot(magichead, ITEM_SLOT_MASK)
	to_chat(human, span_warning("You feel a little horse!"))

/datum/symptom/anime_hair
	name = "Pro-tagonista Syndrome"
	desc = "Causes the infected to believe they are the center of the universe. Outcome may vary depending on symptom strength."
	stage = 3
	max_count = 1
	max_chance = 20
	var/given_katana = FALSE
	max_multiplier = 4
	badness = EFFECT_DANGER_ANNOYING
	var/old_haircolor = ""

/datum/symptom/anime_hair/first_activate(mob/living/carbon/mob)
	RegisterSignal(mob, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/symptom/anime_hair/activate(mob/living/carbon/mob)
	if(ishuman(mob))
		var/mob/living/carbon/human/affected = mob
		var/list/hair_colors = list("pink","red","green","blue","purple")
		var/hair_color = pick(hair_colors)

		old_haircolor = affected.hair_color

		if(!isethereal(affected)) //ethereals have weird custom hair color handling
			switch(hair_color)
				if("pink")
					affected.hair_color = "#e983d8"
				if("red")
					affected.hair_color = "#E01631"
				if("green")
					affected.hair_color = "#008000"
				if("blue")
					affected.hair_color = "#0000FF"
				if("purple")
					affected.hair_color = "#800080"
			affected.update_body()

		if(multiplier)
			if(multiplier >= 1.5)
				//Give them schoolgirl outfits /obj/item/clothing/under/costume/schoolgirl
				var/list/outfits = list(
					/obj/item/clothing/under/costume/schoolgirl,
					/obj/item/clothing/under/costume/schoolgirl/red,
					/obj/item/clothing/under/costume/schoolgirl/green,
					/obj/item/clothing/under/costume/schoolgirl/orange
					)
				var/outfit_path = pick(outfits)
				var/obj/item/clothing/under/costume/schoolgirl/schoolgirl = new outfit_path
				ADD_TRAIT(schoolgirl, TRAIT_NODROP, "disease")
				if(affected.w_uniform && !istype(affected.w_uniform, /obj/item/clothing/under/costume/schoolgirl))
					affected.dropItemToGround(affected.w_uniform,1)
					affected.equip_to_slot(schoolgirl, ITEM_SLOT_ICLOTHING)
				if(!affected.w_uniform)
					affected.equip_to_slot(schoolgirl, ITEM_SLOT_ICLOTHING)
			if(multiplier >= 1.8)
				//Kneesocks /obj/item/clothing/shoes/kneesocks
				var/obj/item/clothing/shoes/kneesocks/kneesock = new /obj/item/clothing/shoes/kneesocks
				ADD_TRAIT(kneesock, TRAIT_NODROP, "disease")
				if(affected.shoes && !istype(affected.shoes, /obj/item/clothing/shoes/kneesocks))
					affected.dropItemToGround(affected.shoes,1)
					affected.equip_to_slot(kneesock, ITEM_SLOT_FEET)
				if(!affected.w_uniform)
					affected.equip_to_slot(kneesock, ITEM_SLOT_FEET)

			if(multiplier >= 2)
				//Regular cat ears /obj/item/clothing/head/kitty
				var /obj/item/clothing/head/costume/kitty/kitty = new  /obj/item/clothing/head/costume/kitty
				if(affected.head && !istype(affected.head,  /obj/item/clothing/head/costume/kitty))
					affected.dropItemToGround(affected.head, TRUE)
					affected.equip_to_slot(kitty, ITEM_SLOT_HEAD)
				if(!affected.head)
					affected.equip_to_slot(kitty, ITEM_SLOT_HEAD)

			if(multiplier >= 2.5 && !given_katana)
				if(multiplier >= 3)
					//REAL katana /obj/item/katana
					var/obj/item/katana/real_katana = new /obj/item/katana
					affected.put_in_hands(real_katana)
				else
					//Toy katana /obj/item/toy/katana
					var/obj/item/toy/katana/fake_katana = new /obj/item/toy/katana
					affected.put_in_hands(fake_katana)
				given_katana = TRUE

/datum/symptom/anime_hair/deactivate(mob/living/carbon/mob)
	UnregisterSignal(mob, COMSIG_MOB_SAY)
	to_chat(mob, "<span class = 'notice'>You no longer feel quite like the main character. </span>")
	if (ishuman(mob))
		var/mob/living/carbon/human/affected = mob
		if(affected.shoes && istype(affected.shoes, /obj/item/clothing/shoes/kneesocks))
			REMOVE_TRAIT(affected.shoes, TRAIT_NODROP, "disease")
		if(affected.w_uniform && istype(affected.w_uniform, /obj/item/clothing/under/costume/schoolgirl))
			REMOVE_TRAIT(affected.w_uniform, TRAIT_NODROP, "disease")

		affected.hair_color = old_haircolor

/datum/symptom/anime_hair/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(prob(20))
		message += pick(" Nyaa", "  nya", "  Nyaa~", "~")

	speech_args[SPEECH_MESSAGE] = message

/datum/symptom/butterfly_skin
	name = "Epidermolysis Bullosa"
	desc = "Inhibits the strength of the infected's skin, causing it to tear on contact."
	stage = 3
	max_count = 1
	badness = EFFECT_DANGER_HARMFUL
	var/skip = FALSE

/datum/symptom/butterfly_skin/activate(mob/living/carbon/mob)
	to_chat(mob, span_warning("Your skin feels a little fragile."))

/datum/symptom/butterfly_skin/deactivate(mob/living/carbon/mob)
	if(!skip)
		to_chat(mob, span_notice("Your skin feels nice and durable again!"))
	..()

/datum/symptom/butterfly_skin/on_touch(mob/living/carbon/mob, toucher, touched, touch_type)
	if(count && !skip)
		var/obj/item/bodypart/part
		if(ishuman(mob))
			var/mob/living/carbon/human/victim = mob
			part = victim.get_bodypart(victim.get_random_valid_zone())
		if(toucher == mob)
			if(part)
				to_chat(mob, span_warning("As you bump into \the [touched], some of the skin on your [part] shears off!"))
				part.take_damage(10)
			else
				to_chat(mob, span_warning("As you bump into \the [touched], some of your skin shears off!"))
				mob.adjustBruteLoss(10)
		else
			if(part)
				to_chat(mob, span_warning("As \the [toucher] [touch_type == DISEASE_BUMP ? "bumps into" : "touches"] you, some of the skin on your [part] shears off!"))
				to_chat(toucher, span_danger("As you [touch_type == DISEASE_BUMP ? "bump into" : "touch"] \the [mob], some of the skin on \his [part] shears off!"))
				part.take_damage(10)
			else
				to_chat(mob, span_warning("As \the [toucher] [touch_type == DISEASE_BUMP ? "bumps into" : "touches"] you, some of your skin shears off!"))
				to_chat(toucher, span_danger("As you [touch_type == DISEASE_BUMP ? "bump into" : "touch"] \the [mob], some of \his skin shears off!"))
				mob.adjustBruteLoss(10)

/datum/symptom/thick_blood
	name = "Hyper-Fibrinogenesis"
	desc = "Causes the infected to oversynthesize coagulant, as well as rapidly restore lost blood."
	stage = 3
	badness = EFFECT_DANGER_HELPFUL

/datum/symptom/thick_blood/activate(mob/living/carbon/mob)
	var/mob/living/carbon/human/victim = mob
	if (ishuman(victim))
		if(victim.is_bleeding())
			victim.restore_blood()
			to_chat(victim, span_notice("You feel your blood regenerate, and your bleeding to stop!"))

/datum/symptom/teratoma
	name = "Teratoma Syndrome"
	desc = "Causes the infected to oversynthesize stem cells engineered towards organ generation, causing damage to the host's organs in the process. Said generated organs are expelled from the body upon completion."
	stage = 3
	badness = EFFECT_DANGER_HARMFUL

/datum/symptom/teratoma/activate(mob/living/carbon/mob)
	var/fail_counter = 0
	var/not_passed = TRUE
	var/obj/item/organ/spawned_organ
	while(not_passed && fail_counter <= 10)
		var/organ_type = pick(typesof(/obj/item/organ/internal))
		spawned_organ = new organ_type(get_turf(mob))
		if(spawned_organ.status != ORGAN_ORGANIC)
			qdel(spawned_organ)
			fail_counter++
			continue
		not_passed = FALSE

	if(!not_passed)
		if(ismouse(mob))
			var/mob/living/basic/mouse/mouse = mob
			mouse.splat() //tumors are bad for you, tumors equal to your body in size doubley so
		if(ismonkey(mob)) //monkeys are smaller and thus have less space for human-organ sized tumors
			for(var/i in 1 to 3)
				mob.adjustOrganLoss(pick(ORGAN_SLOT_HEART, ORGAN_SLOT_LUNGS, ORGAN_SLOT_STOMACH, ORGAN_SLOT_LIVER), 30)
		mob.adjustOrganLoss(pick(ORGAN_SLOT_HEART, ORGAN_SLOT_LUNGS, ORGAN_SLOT_STOMACH, ORGAN_SLOT_LIVER), 25)
		mob.visible_message(span_warning("\A [spawned_organ.name] is extruded from \the [mob]'s body and falls to the ground!"),span_warning("\A [spawned_organ.name] is extruded from your body and falls to the ground!"))

/datum/symptom/damage_converter
	name = "Toxic Compensation"
	desc = "Stimulates cellular growth within the body, causing it to regenerate tissue damage. Repair done by these cells causes toxins to build up in the body."
	badness = EFFECT_DANGER_FLAVOR
	stage = 3
	chance = 10
	max_chance = 50
	multiplier = 5
	max_multiplier = 10

/datum/symptom/damage_converter/activate(mob/living/carbon/mob)
	if(mob.getFireLoss() > 0 || mob.getBruteLoss() > 0)
		var/get_damage = rand(1, 3)
		mob.adjustFireLoss(-get_damage)
		mob.adjustBruteLoss(-get_damage)
		mob.adjustToxLoss(max(1,get_damage * multiplier / 5))

/datum/symptom/mommi_hallucination
	name = "Supermatter Syndrome"
	desc = "Causes the infected to experience engineering-related hallucinations."
	stage = 3
	badness = EFFECT_DANGER_ANNOYING

/datum/symptom/mommi_hallucination/activate(mob/living/carbon/mob)
	if(prob(50))
		mob << sound('sound/effects/supermatter.ogg', volume = 25)

	var/mob/living/silicon/robot/mommi = /mob/living/silicon/robot
	for(var/mob/living/M in viewers(mob))
		if(M == mob)
			continue

		var/image/crab = image(icon = null)
		crab.appearance = initial(mommi.appearance)

		crab.loc = M
		crab.override = 1

		var/client/client = mob.client
		if(client)
			client.images += crab
		var/duration = rand(60 SECONDS, 120 SECONDS)

		spawn(duration)
			if(client)
				client.images.Remove(crab)

	var/list/turf_list = list()
	for(var/turf/turf in spiral_block(get_turf(mob), 40))
		if(prob(4))
			turf_list += turf
	if(turf_list.len)
		for(var/turf/open/floor/turf in turf_list)
			var/image/supermatter = image('icons/obj/engine/supermatter.dmi', turf ,"sm", ABOVE_MOB_LAYER)

			var/client/client = mob.client
			if(client)
				client.images += supermatter
			var/duration = rand(60 SECONDS, 120 SECONDS)

			spawn(duration)
				if(client)
					client.images.Remove(supermatter)


/datum/symptom/wendigo_hallucination
	name = "Eldritch Mind Syndrome"
	desc = "UNKNOWN"
	badness = EFFECT_DANGER_ANNOYING
	stage = 3


/datum/symptom/wendigo_hallucination/first_activate(mob/living/carbon/mob)
	RegisterSignal(mob, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/symptom/wendigo_hallucination/deactivate(mob/living/carbon/mob)
	UnregisterSignal(mob, COMSIG_MOB_SAY)

/datum/symptom/wendigo_hallucination/activate(mob/living/carbon/mob)
	if(!ishuman(mob))
		return
	var/mob/living/carbon/human/H = mob
	H.adjust_jitter(10 SECONDS)

	//creepy sounds copypasted from hallucination code
	var/list/possible_sounds = list(
		'monkestation/code/modules/virology/sounds/ghost.ogg', 'monkestation/code/modules/virology/sounds/ghost2.ogg', 'monkestation/code/modules/virology/sounds/heart_beat_single.ogg', 'monkestation/code/modules/virology/sounds/ear_ring_single.ogg', 'monkestation/code/modules/virology/sounds/screech.ogg',\
		'monkestation/code/modules/virology/sounds/behind_you1.ogg', 'monkestation/code/modules/virology/sounds/behind_you2.ogg', 'monkestation/code/modules/virology/sounds/far_noise.ogg', 'monkestation/code/modules/virology/sounds/growl1.ogg', 'monkestation/code/modules/virology/sounds/growl2.ogg',\
		'monkestation/code/modules/virology/sounds/growl3.ogg', 'monkestation/code/modules/virology/sounds/im_here1.ogg', 'monkestation/code/modules/virology/sounds/im_here2.ogg', 'monkestation/code/modules/virology/sounds/i_see_you1.ogg', 'monkestation/code/modules/virology/sounds/i_see_you2.ogg',\
		'monkestation/code/modules/virology/sounds/look_up1.ogg', 'monkestation/code/modules/virology/sounds/look_up2.ogg', 'monkestation/code/modules/virology/sounds/over_here1.ogg', 'monkestation/code/modules/virology/sounds/over_here2.ogg', 'monkestation/code/modules/virology/sounds/over_here3.ogg',\
		'monkestation/code/modules/virology/sounds/turn_around1.ogg', 'monkestation/code/modules/virology/sounds/turn_around2.ogg', 'monkestation/code/modules/virology/sounds/veryfar_noise.ogg', 'monkestation/code/modules/virology/sounds/wail.ogg')
	mob.playsound_local(mob.loc, pick(possible_sounds))



/datum/symptom/wendigo_hallucination/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	message = replacetext(message,"I","we")
	message = replacetext(message,"me","us")
	speech_args[SPEECH_MESSAGE] = message


/datum/symptom/asphyxiation
	name = "Acute respiratory distress syndrome"
	desc = "The virus causes shrinking of the host's lungs, causing severe asphyxiation. May also lead to brain damage in critical patients."
	badness = EFFECT_DANGER_DEADLY
	max_chance = 10
	multiplier = 5
	stage = 3

/datum/symptom/asphyxiation/activate(mob/living/carbon/mob)
	mob.emote("gasp")
	if(prob(20) && multiplier >= 4 && iscarbon(mob))
		mob.reagents.add_reagent_list(list(/datum/reagent/toxin/pancuronium = 3, /datum/reagent/toxin/sodium_thiopental = 3))
	mob.adjustOxyLoss(rand(5,15) * multiplier)
	if(mob.getOxyLoss() >= 120 && multiplier == 5)
		mob.adjustOxyLoss(rand(5,7) * multiplier)
		mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, multiplier)

/datum/symptom/wizarditis
	name = "Wizarditis"
	max_multiplier = 4
	stage = 3
	desc = "Some speculate that this virus is the cause of the Space Wizard Federation's existence. Subjects affected show the signs of brain damage, yelling obscure sentences or total gibberish. On late stages subjects sometime express the feelings of inner power, and, cite, 'the ability to control the forces of cosmos themselves!' A gulp of strong, manly spirits usually reverts them to normal, humanlike, condition."
	badness = EFFECT_DANGER_HARMFUL

/datum/symptom/wizarditis/activate(mob/living/carbon/affected_mob)
	switch(round(multiplier))
		if(2)
			if(prob(10))
				affected_mob.say(pick("You shall not pass!", "Expeliarmus!", "By Merlins beard!", "Feel the power of the Dark Side!"), forced = "wizarditis")
			if(prob(10))
				to_chat(affected_mob, span_danger("You feel [pick("that you don't have enough mana", "that the winds of magic are gone", "an urge to summon familiar")]."))
		if(3)
			if(prob(10))
				affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!", "STI KALY!", "TARCOL MINTI ZHERI!"), forced = "wizarditis")
			if(prob(10))
				to_chat(affected_mob, span_danger("You feel [pick("the magic bubbling in your veins","that this location gives you a +1 to INT","an urge to summon familiar")]."))
		if(4)
			if(prob(10))
				affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!","STI KALY!","EI NATH!"), forced = "wizarditis")
				return
			if(prob(5))
				to_chat(affected_mob, span_danger("You feel [pick("the tidal wave of raw power building inside","that this location gives you a +2 to INT and +1 to WIS","an urge to teleport")]."))
				spawn_wizard_clothes(50, affected_mob)
			if(prob(1))
				teleport(affected_mob)


/datum/symptom/wizarditis/proc/spawn_wizard_clothes(chance = 0, mob/living/carbon/affected_mob)
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/wizard = affected_mob
		if(prob(chance))
			if(!istype(wizard.head, /obj/item/clothing/head/wizard))
				if(!wizard.dropItemToGround(wizard.head))
					qdel(wizard.head)
				wizard.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(wizard), ITEM_SLOT_HEAD)
			return
		if(prob(chance))
			if(!istype(wizard.wear_suit, /obj/item/clothing/suit/wizrobe))
				if(!wizard.dropItemToGround(wizard.wear_suit))
					qdel(wizard.wear_suit)
				wizard.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(wizard), ITEM_SLOT_OCLOTHING)
			return
		if(prob(chance))
			if(!istype(wizard.shoes, /obj/item/clothing/shoes/sandal/magic))
				if(!wizard.dropItemToGround(wizard.shoes))
					qdel(wizard.shoes)
			wizard.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal/magic(wizard), ITEM_SLOT_FEET)
			return
	else
		var/mob/living/carbon/wizard = affected_mob
		if(prob(chance))
			var/obj/item/staff/staff = new(wizard)
			if(!wizard.put_in_hands(staff))
				qdel(staff)


/datum/symptom/wizarditis/proc/teleport(mob/living/carbon/affected_mob)
	var/list/theareas = get_areas_in_range(80, affected_mob)
	for(var/area/space/unsafe in theareas)
		theareas -= unsafe

	if(!theareas || !theareas.len)
		return

	var/area/thearea = pick(theareas)

	var/list/L = list()
	var/turf/mob_turf = get_turf(affected_mob)
	for(var/turf/T in get_area_turfs(thearea.type))
		if(!is_valid_z_level(T, mob_turf))
			continue
		if(T.name == "space")
			continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L)
		return

	affected_mob.say("SCYAR NILA [uppertext(thearea.name)]!", forced = "wizarditis teleport")
	affected_mob.forceMove(pick(L))

	return

/datum/symptom/polyvitiligo
	name = "Chroma Imbalance"
	desc = "The virus replaces the melanin in the skin with reactive pigment."
	stage = 3
	max_multiplier = 6
	badness = EFFECT_DANGER_FLAVOR

/datum/symptom/polyvitiligo/activate(mob/living/carbon/mob)
	if(!iscarbon(mob))
		return
	switch(round(multiplier, 1))
		if(5)
			var/static/list/banned_reagents = list(/datum/reagent/colorful_reagent/powder/invisible, /datum/reagent/colorful_reagent/powder/white)
			var/color = pick(subtypesof(/datum/reagent/colorful_reagent/powder) - banned_reagents)
			if(mob.reagents.total_volume <= (mob.reagents.maximum_volume/10)) // no flooding humans with 1000 units of colorful reagent
				mob.reagents.add_reagent(color, 5 * multiplier)
		else
			if (prob(50)) // spam
				mob.visible_message(span_warning("[mob] looks rather vibrant..."), span_notice("The colors, man, the colors..."))

/datum/symptom/metabolism
	name = "Metabolic Boost"
	desc = "The virus causes the host's metabolism to accelerate rapidly, making them process chemicals twice as fast,\
		but also causing increased hunger."
	max_multiplier = 5
	stage = 3
	badness = EFFECT_DANGER_HELPFUL


/datum/symptom/metabolism/activate(mob/living/carbon/mob)
	if(!iscarbon(mob))
		return

	mob.reagents.metabolize(mob, (multiplier * 0.5) * SSMOBS_DT, 0, can_overdose=TRUE) //this works even without a liver; it's intentional since the virus is metabolizing by itself
	mob.overeatduration = max(mob.overeatduration - 4 SECONDS, 0)
	mob.adjust_nutrition(-(4 + multiplier) * HUNGER_FACTOR) //Hunger depletes at 10x the normal speed
	if(prob(2 * multiplier))
		to_chat(mob, span_notice("You feel an odd gurgle in your stomach, as if it was working much faster than normal."))

