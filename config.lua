Config = {

	Text = {
		['someone_is_waiting'] = 'Alguien usó la campana de escritorio',
		['press_to_call'] = '[~g~E~w~] Presiona para usar la campana de escritorio',
		['please_wait'] = 'Personal informado, por favor espere ~g~'
	},

	Desks = { --Setup deskbells for each job
		{coords = vector3(441.96099853516,-980.16595458984,31.893302917 - 0.9), job = 'police'},
		{coords = vector3(115.88848114014,6630.3090820313,33.18488693237 - 0.9), job = 'mechanic'},
		{coords = vector3(-239.18188476563,6219.2143554688,33.0147743225 - 0.9), job = 'cardealer'}                
	}	
}

-- Only change if you know what are you doing!
function SendNotice(msg)
	QBCore.Functions.Notify(msg)
end