#priority -1

import crafttweaker.oredict.IOreDictEntry;
import crafttweaker.item.IItemStack;

print("Locking down TConstruct materials and modifiers....");

mods.compatskills.MaterialLock.addMaterialLock("wood", "reskillable:building|2");
mods.compatskills.MaterialLock.addMaterialLock("stone", "reskillable:building|2");
mods.compatskills.MaterialLock.addMaterialLock("flint", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("cactus", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("bone", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("obsidian", "reskillable:building|12");
mods.compatskills.MaterialLock.addMaterialLock("prismarine", "reskillable:building|16");
mods.compatskills.MaterialLock.addMaterialLock("endstone", "reskillable:building|8");
mods.compatskills.MaterialLock.addMaterialLock("paper", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("sponge", "reskillable:building|16");
mods.compatskills.MaterialLock.addMaterialLock("firewood", "reskillable:building|8");
mods.compatskills.MaterialLock.addMaterialLock("iron", "reskillable:building|8");
mods.compatskills.MaterialLock.addMaterialLock("pigiron", "reskillable:building|9");
mods.compatskills.MaterialLock.addMaterialLock("knightslime", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("slime", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("blueslime", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("magmaslime", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("blueslime", "reskillable:building|10");
mods.compatskills.MaterialLock.addMaterialLock("netherrack", "reskillable:building|8");
mods.compatskills.MaterialLock.addMaterialLock("cobalt", "reskillable:building|16");
mods.compatskills.MaterialLock.addMaterialLock("ardite", "reskillable:building|20");
mods.compatskills.MaterialLock.addMaterialLock("manyullyn", "reskillable:building|28");
mods.compatskills.MaterialLock.addMaterialLock("copper", "reskillable:building|6");
mods.compatskills.MaterialLock.addMaterialLock("bronze", "reskillable:building|7");
mods.compatskills.MaterialLock.addMaterialLock("lead", "reskillable:building|9");
mods.compatskills.MaterialLock.addMaterialLock("silver", "reskillable:building|9");
mods.compatskills.MaterialLock.addMaterialLock("electrum", "reskillable:building|12");
mods.compatskills.MaterialLock.addMaterialLock("steel", "reskillable:building|16");
mods.compatskills.MaterialLock.addMaterialLock("string", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("flint", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("slimevine_blue", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("slimevine_purple", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("vine", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("blaze", "reskillable:building|12");
mods.compatskills.MaterialLock.addMaterialLock("reed", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("ice", "reskillable:building|6");
mods.compatskills.MaterialLock.addMaterialLock("endrod", "reskillable:building|16");
mods.compatskills.MaterialLock.addMaterialLock("feather", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("slimeleaf_blue", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("slimeleaf_orange", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("slimeleaf_purple", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("leaf", "reskillable:building|4");
mods.compatskills.MaterialLock.addMaterialLock("ma.prosperity", "reskillable:building|8", "reskillable:magic|8");
mods.compatskills.MaterialLock.addMaterialLock("ma.soulium", "reskillable:building|8", "reskillable:magic|8");
mods.compatskills.MaterialLock.addMaterialLock("ma.base_essence", "reskillable:building|8", "reskillable:magic|8");
mods.compatskills.MaterialLock.addMaterialLock("ma.inferium", "reskillable:building|12", "reskillable:magic|12");
mods.compatskills.MaterialLock.addMaterialLock("ma.prudentium", "reskillable:building|16", "reskillable:magic|16");
mods.compatskills.MaterialLock.addMaterialLock("ma.intermedium", "reskillable:building|24", "reskillable:magic|24");
mods.compatskills.MaterialLock.addMaterialLock("ma.superium", "reskillable:building|28", "reskillable:magic|28");
mods.compatskills.MaterialLock.addMaterialLock("ma.supremium", "reskillable:building|32", "reskillable:magic|32");

print("Finished locking down TConstruct materials and modifiers");

print("Editing frost rods and blizz rods");
val coldRod = <ore:coldRod>;
coldRod.addItems([<simpledifficulty:frost_rod>,<thermalfoundation:material:2048>]);

// compatability for frostRod and blizzRod
recipes.addShaped("lolarecipe71",<simpledifficulty:chiller>,
 [[<ore:coldRod>,null,<ore:coldRod>],
  [<ore:coldRod>,<ore:cobblestone>,<ore:coldRod>],
  [<ore:cobblestone>,<minecraft:redstone>,<ore:cobblestone>]]);

recipes.addShapeless("frosttoblizzpowder", <thermalfoundation:material:2049>, [<simpledifficulty:frost_powder>]);
recipes.addShapeless("blizztofrostpowder", <simpledifficulty:frost_powder>, [<thermalfoundation:material:2049>]);

print("Finished editing frost rods and blizz rods");

// Silver ingot from pulverized silver
furnace.addRecipe(<thermalfoundation:material:130>, <thermalfoundation:material:66>);
// Silver ingot from silver dust
furnace.addRecipe(<thermalfoundation:material:130>, <mekanism:dust:5>);

var oreCrystalHeart as IOreDictEntry = <ore:oreCrystalHeart>;
oreCrystalHeart.addItems([<scalinghealth:crystalore>]);