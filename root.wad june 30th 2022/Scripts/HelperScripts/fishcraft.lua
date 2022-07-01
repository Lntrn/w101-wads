
function main()

-- crafting equipment!
Log("giving the player the level and equipment to craft");

Server("SetCraftingLevel", "20")
Server("Createwizitem", "HOUSE_crafting_furniture_01");
Server("Createwizitem", "HOUSE_crafting_equipable_01");
Server("Createwizitem", "HOUSE_crafting_spells_01");
Server("Createwizitem", "HOUSE_crafting_generic_01");

Server("removeallinventory");
Server("ClearFishBasket");

Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");
Server("addtreasurecard", "Fire Shield TC");


Server("addtreasurecard", "Death Shield TC");
Server("addtreasurecard", "Death Shield TC");
Server("addtreasurecard", "Death Shield TC");
Server("addtreasurecard", "Death Shield TC");
Server("addtreasurecard", "Death Shield TC");

Server("addtreasurecard", "Snow Shield TC");
Server("addtreasurecard", "Snow Shield TC");
Server("addtreasurecard", "Snow Shield TC");
Server("addtreasurecard", "Snow Shield TC");
Server("addtreasurecard", "Snow Shield TC");

Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");
Server("addtreasurecard", "Life Shield TC");

Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");
Server("addtreasurecard", "Myth Shield TC");

Server("addtreasurecard", "Storm Shield TC");
Server("addtreasurecard", "Storm Shield TC");
Server("addtreasurecard", "Storm Shield TC");
Server("addtreasurecard", "Storm Shield TC");
Server("addtreasurecard", "Storm Shield TC");

Server("addrecipe", "Recipe-HOUSE_AquariumLarge");
Server("addrecipe", "Recipe-HOUSE_AquariumTall");
Server("addrecipe", "Recipe-HOUSE_AquariumLong");
Server("addrecipe", "Recipe-HOUSE_AquariumRegWhopper");
Server("addrecipe", "Recipe-HOUSE_AquariumTallWhopper");
Server("addrecipe", "Recipe-HOUSE_AquariumLargeWhopper");
Server("addrecipe", "Recipe-HOUSE_AquariumLargeSmlFry");
Server("addrecipe", "Recipe-HOUSE_AquariumRegSmlFry");
Server("addrecipe", "Recipe-HOUSE_AquariumTallSmlFry");


----------------------------------------------------------------------------
Log("Creating items for Large Keeper Aquarium")

--Fish items
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 
Server("addfish", "1302322", "1"); 

--reagents

--rubies
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
Server("Createwizitem", "106946");
--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--Blood Moss
Server("Createwizitem", "106960");
Server("Createwizitem", "106960");
Server("Createwizitem", "106960");
Server("Createwizitem", "106960");
Server("Createwizitem", "106960");

-------------------------------------------------------------------------

Log("Creating items for Large Small Fry Aquarium")

--Charred Dekoi-------------
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");
Server("Addfish", "1302353", "1");


--Amethyst-------------------
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");
Server("Createwizitem", "106948");

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

Server("Createwizitem", "106970");
Server("Createwizitem", "106970");
Server("Createwizitem", "106970");
Server("Createwizitem", "106970");
Server("Createwizitem", "106970");

------------------------------------------------------------
Log("Creating items for Large Whopper Aquarium")

--Black Coal

Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");
Server("Createwizitem", "106953");

--Fabled Dekoi
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");
Server("Addfish", "1302356", "1");

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--Water Lily

Server("Createwizitem", "106940");
Server("Createwizitem", "106940");
Server("Createwizitem", "106940");
Server("Createwizitem", "106940");
Server("Createwizitem", "106940");

----------------------------------------------------------
Log("Creating items for Regular Keeper Aquarium")

--Treant Fish
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 
Server("addfish", "1302325", "1"); 

--jade
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");
Server("Createwizitem", "106952");

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--diamonds
Server("Createwizitem", "106938");
Server("Createwizitem", "106938");
Server("Createwizitem", "106938");
Server("Createwizitem", "106938");
Server("Createwizitem", "106938");

-----------------------------------------------------------

Log("Creating items for Regular Small Fry Aquarium");

--onyx
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");
Server("Createwizitem", "106951");

--Frosted Dekoi
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--Fire Blossom
Server("Createwizitem", "106968");
Server("Createwizitem", "106968");
Server("Createwizitem", "106968");
Server("Createwizitem", "106968");
Server("Createwizitem", "106968");

-------------------------------------------
Log("Creating items for Regular Whopper Aquarium");

--sapphire
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");

--Frost Dekoi
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 
Server("addfish", "1302354", "1"); 

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--Black Pearl
Server("Createwizitem", "106966");
Server("Createwizitem", "106966");
Server("Createwizitem", "106966");
Server("Createwizitem", "106966");
Server("Createwizitem", "106966");

-------------------------------------------
Log("Creating items for Tall Keeper Aquarium");

--gullfish grouper

Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 
Server("addfish", "1302323", "1"); 

-- Sapphire
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");
Server("Createwizitem", "106947");

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--nightshade
Server("Createwizitem", "106936");
Server("Createwizitem", "106936");
Server("Createwizitem", "106936");
Server("Createwizitem", "106936");
Server("Createwizitem", "106936");

---------------------------------------------
Log("Creating items for Tall Small Fry Aquarium");

--Citrine
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");
Server("Createwizitem", "106949");

--Mud Dekoi
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 
Server("addfish", "1302357", "1"); 

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--ancient scroll
Server("Createwizitem", "106962");
Server("Createwizitem", "106962");
Server("Createwizitem", "106962");
Server("Createwizitem", "106962");
Server("Createwizitem", "106962");

-----------------------------------------------

Log("Creating items for Tall Whopper Aquarium");

--Peridot
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");
Server("Createwizitem", "106950");

--Corroded Dekoi
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 
Server("addfish", "1302358", "1"); 

--mist wood
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");
Server("Createwizitem", "106931");

--leather straps
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");
Server("Createwizitem", "1206300");

--Spring
Server("Createwizitem", "106964");
Server("Createwizitem", "106964");
Server("Createwizitem", "106964");
Server("Createwizitem", "106964");
Server("Createwizitem", "106964");


Log(COMPLETE); Sleep(1);

end

