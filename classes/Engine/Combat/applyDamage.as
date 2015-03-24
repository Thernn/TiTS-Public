package classes.Engine.Combat 
{
	import classes.Characters.PlayerCharacter;
	import classes.Creature;
	import classes.Engine.Combat.DamageTypes.DamageResult;
	import classes.Engine.Combat.DamageTypes.TypeCollection;
	import classes.Engine.Combat.DamageTypes.DamageType;
	import classes.Engine.Interfaces.output;
	import classes.Engine.Utility.possessive;
	import classes.Items.Guns.Goovolver;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public function applyDamage(baseDamage:TypeCollection, attacker:Creature, target:Creature, special:String = ""):void
	{
		/* 
		 * Do not apply randomisation here -- if it is required, apply it prior to applyDamage()
		 * 
		 * Any bonuses you want to include should be merged into various places throughout calculateDamage and the function it calls directly.
		 * 
		 * calculateDamage handles all of the bonus damage calculations, defensive reductions, etc. It spits back a singular result -- damageResult -- that contains all of the information required to output messages about the damage that occured.
		 */
		var damageResult:DamageResult = calculateDamage(baseDamage, target, attacker, special);
		
		// Damage has already been applied by this point, so we can skip output if we want...
		if (special == "supress") return;
		else if (special == "minimal" && damageResult.totalDamage > 0) output(" <b>(" + damageResult.totalDamage + "</b>)");
		
		// Begin message outpuuuuut.
		if (damageResult.wasCrit == true)
		{
			output("\n<b>Critical hit!</b>");
		}
		
		if (damageResult.wasSneak == true)
		{
			output("\n<b>Sneak attack!</b>");
		}
		
		// Shield damage happened, but the target still has shields.
		if (damageResult.shieldDamage > 0 && target.shieldsRaw > 0)
		{
			if (target is PlayerCharacter)
			{
				output(" Your shield crackles but holds. (<b>" + damageResult.shieldDamage + "</b>)");
			}
			else
			{
				if (target.plural) 
				{
					output(" " + target.a + possessive(target.short) + " shields crackle but hold. (<b> " + damageResult.shieldDamage + "</b>)");
				}
				else
				{
					output(" " + target.a + possessive(target.short) + " shield crackles but holds. (<b>" + damageResult.shieldDamage + "</b>)"); 
				}
			}
		}
		// Shield damage happened, but the target no longer has shields.
		else if (damageResult.shieldDamage > 0 && target.shieldsRaw <= 0)
		{
			if (target is PlayerCharacter) 
			{
				output(" There is a concussive boom and tingling aftershock of energy as your shield is breached. (<b>" + damageResult.shieldDamage + "</b>)");
			}
			else 
			{
				if (target.plural) 
				{
					output(" There is a concussive boom and tingling aftershock of energy as " + target.a + possessive(target.short) + " shields are breached. (<b>" + damageResult.shieldDamage + "</b>)");
				}
				else 
				{
					output(" There is a concussive boom and tingling aftershock of energy as " + target.a + possessive(target.short) + " shield is breached. (<b>" + damageResult.shieldDamage + "</b>)");
				}
			}
		}
		
		// HP Damage
		if (damageResult.hpDamage > 0 && damageResult.shieldDamage > 0)
		{
			if (target is PlayerCharacter) 
			{
				output(" The attack continues on to connect with you! (<b>" + damageResult.hpDamage + "</b>)");
			}
			else 
			{
				output(" The attack continues on to connect with " + target.a + target.short + "! (<b>" + damageResult.hpDamage + "</b>)");
			}
		}
		// HP damage, didn't pass through shield
		else if (damageResult.hpDamage > 0 && damageResult.shieldDamage == 0)
		{
			output(" (<b>" + damageResult.hpDamage + "</b>)");
		}
		
		// Lust damage output
		
		// Attack included lust damage, but was resisted.
		if (damageResult.shieldDamage <= 0 && damageResult.hpDamage <= 0 && damageResult.lustResisted == true)
		{
			// Any special resistance message overrides
			if (special == "goovolver")
			{
				output("\n<b>" + target.capitalA + target.short + " ");
				if (target.plural) output(" don't");
				else output(" doesn't");
				output(" seem the least bit bothered by the miniature goo crawling over them. (0)</b>\n");
			}
			else
			{
				// Only if the incoming damage is pure-lust
				if (damageResult.shieldDamage == 0 && damageResult.hpDamage == 0)
				{
					output("\n<b>" + target.capitalA + target.short + " ");
					if (target.plural) output(" don't");
					else output(" doesn't");
					output(" seem at all interested in your teasing. <b>(0)</b>\n");
				}
			}
		}
		// Lust damage happened
		else if (damageResult.shieldDamage <= 0 && damageResult.hpDamage <= 0 && damageResult.lustDamage > 0)
		{
			if (special == "goovolver")
			{
				output(" A tiny " + (attacker.rangedWeapon as Goovolver).randGooColour() + " goo, vaguely female in shape, pops out and starts to crawl over " + target.mf("him", "her") + ", teasing " + target.mf("his", "her") + " most sensitive parts! <b>(" + damageResult.lustDamage + "</b>)");
			}
			else
			{
				// TODO
			}
		}
	}

}