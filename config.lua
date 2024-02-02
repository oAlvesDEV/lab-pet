PET = {
    -- "/petinfo" para desligar a parte que aparece quando você se aproxima de animais de estimação.
    debugMode = false, -- Certain prints are turned on, if you don't understand this you don't need to turn it on at all, it's here to help us understand where the error is when the script has problems.
    -- 
    petInfoCommand = "petinfo", -- Comando usado para desligar as informações do pet na tela
    showPetCommand = "showmyPets", -- Blip mostrando a localização do animal de estimação
    -- 
    DefaultPetIMG = "https://cdn.discordapp.com/attachments/919180635388653618/1035353250242777138/pet-logo-design-paw-vector-animal-shop-business_53876-136741.webp",
    DefaultPetName = "Amazing Pets", -- se o nome for "", o sistema irá preenchê-lo automaticamente com este aqui.
    -- Pet Shop area
    petBuyCoords = vector3(-1368.35, 56.31, 53.7), -- purchase marker part of the pet
    petShowCoords = vector4(-1366.09,56.68,54.1,119.19),-- Where to spawn when in the pet purchase menu
    -- SQL 
    Mysql = "oxmysql",
    --NEEDS SYSETM
    petHealFillItem = "pethealth", -- the pad's full of health, hunger and thirst remain as they are.
    petHealFillAmount = 97, -- How much to fill when used --max 97

    petHungryFillItem = "petfood", -- item to fill pet's hunger
    petHungryFillAmount = 97,  -- How much to fill when used --max 97

    petThirstFillItem = "petthirst", -- item to fill pet's thirst
    petThirstFillAmount = 50, -- How much to fill when used --max 97
    -- DEADTH SIDE
    PermanentlyDie = false, -- if "true", the pet will be directly deleted when it dies and will never come back.
    -- UPTADES
    UpdateAnimInterval = 0, -- If the pad is going into animation, like dying, etc., how many seconds will it be checked?
    UpdateInterval = 1, -- "1minutes" will update all pets' death, hunger, thirst, location and many other updates every 1 minute (it will be good to do this in a short time to live without problems).
    UpdateXPInterval = 10, -- "1minutes" Every 1 minute all pets will gain a set amount of xp.
    LevelingDifficulty = 20,--% Indicates the health starvation value that the pet will have directly when you buy it the difficulty to level up in [ % ]  
    --
    lossOfLife_hungry = 3, -- Selects how many lives to take when Hunger drops to 0.
    lossOfLife_thirst = 1, -- Selects how many lives to take when Thirst drops to 0.
    --
    earnXPAmount = 10, -- "UpdateXPInterval" time during which all pets will gain +1 xp for the specified amount of time
    --
    NotificationInScript = true, -- If this is "true" you will use the script's own notify system.
    Notification = function(text, inform) -- You can put your own notify text here
        
    end,
    PetMiniMap = { showblip = true, sprite = 442, colour = 2, shortRange = false },
    -- ROPE SIDE
    ropeLength = 4, -- How long the towing rope should be (in meters) I highly recommend keeping it between 6 and 10 meters
    ropeItem = "petrope",
    -- Ball
    petBallItem = "petball",

    --Pet Attack
    chaseDistance = 50.0,
    chaseIndicator = true, -- huge marker on hunted target head
    petAttackKeyCode = 49, --https://docs.fivem.net/docs/game-references/controls/
    petAttackKeyCodeDisplay = "PRESS ~g~F~w~PARA ATACAR O ALVO", --Displaying Text
    -- PET Interact
    petInteractKeyCode = 38, -- [ E ] https://docs.fivem.net/docs/game-references/controls/
    -- Random animations
    RandomAnim = {
        ["dog"] = {
            -- {
            --     animName = "creatures@rottweiler@amb@",
            --     animID = "hump_loop_chop" 
            -- },
            {
                animName = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                animID = "idle_b" 
            },
            {
                animName = "creatures@rottweiler@amb@world_dog_barking@idle_a",
                animID = "idle_a" 
            },
            {
                animName = "creatures@rottweiler@amb@sleep_in_kennel@",
                animID = "sleep_in_kennel" 
            }, 
            
        },
        ["cat"] = {
            {
                animName = "creatures@cat@amb@world_cat_sleeping_ground@base",
                animID = "base" 
            }, 
            {
                animName = "creatures@cat@amb@world_cat_sleeping_ledge@base",
                animID = "base" 
            }, 
            -- {
            --     animName = "creatures@cat@step",
            --     animID = "step_lft" 
            -- }, 
            
        },
        ["bird"] = {
            {
                animName = "creatures@chickenhawk@amb@world_chickenhawk_feeding@base",
                animID = "base" 
            }, 
            {
                animName = "creatures@cormorant@amb@world_cormorant_standing@base",
                animID = "base" 
            },   
        },
        ["coguar"] = {
            { -- rest
                animName = "creatures@cougar@amb@world_cougar_rest@idle_a",
                animID = "idle_a" 
            }, 
            { -- getup
                animName = "creatures@cougar@getup",
                animID = "idle_a" 
            },   
        }  
    },
    --

    --[[ 
        petTexureID  => {
            Rottweiler => Hiç Rengi yok
            Shepherd => {
                [0] : Basic,
                [1] : White and black,
                [2] : Brown,
            } 
            Husky => {
                [0] : Basic,
                [1] : Gold Brown,
                [2] : White, 
            }
            Retriever => {
                [0] : Basic,
                [1] : Black,
                [2] : White Gold, 
                [3] : Brown, 
            }
            Cat => {
                [0] : Basic,
                [1] :  White And Black,
                [2] : Brown- like a redhead :D, 
            }
        }

    ]]
    
    AvailablePets = {
        {
            price = 1,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet. 
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Rottweiler",
            petLabel = "The Rottweiler is one of the oldest known dog breeds,[1] dating back to the Roman Empire. With their herding and guarding characteristics, they have been the helpers of people in many matters. It is even recognized as the breed that led the herds of the Roman armies crossing the alpine mountains and protected the people in the caravan.",
            petIMG = "https://cdn.discordapp.com/attachments/697541709713899545/1050974691810082896/domestic-dog_thumb_4x3.webp",
            pedHash = "a_c_chop",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Femea", -- Pet'in cinsiyeti "M ya da F" tarzında olacaktır M = male   F = female
            petLevel = 5, -- Pet'i satın aldığınız zaman otomatik olarak olacak olan leveli
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },    
        {
            price = 1,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Popu",
            petLabel = "O Rottweiler é uma das raças de cães mais antigas conhecidas,[1] que remonta ao Império Romano. Com suas características de pastoreio e guarda, eles têm ajudado as pessoas em muitos assuntos. É ainda reconhecida como a raça que liderou os rebanhos dos exércitos romanos atravessando as montanhas alpinas e protegeu as pessoas na caravana..pu",
            petIMG = "",
            pedHash = "a_c_westy",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Femea",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        }, 
        {
            price = 2,
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 5, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 5, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            
            petName = "Retriever",
            petLabel = "Golden Retriever, dog breed. It originated in Scotland around the 19th century and was used as an aid in hunting activities at that time.",
            petIMG = "https://cdn.discordapp.com/attachments/697541709713899545/1050974692388900954/unnamed.png",
            pedHash = "a_c_retriever",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.s
            petGender = "Macho",
            petBoughtAnim = true, -- With or without a purchase animation?
            petLevel = 10,
            listOf = "dog", -- which list to be on
        },  
        {
            price = 1,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Pug",
            petLabel = "O Rottweiler é uma das raças de cães mais antigas conhecidas,[1] que remonta ao Império Romano. Com suas características de pastoreio e guarda, eles têm ajudado as pessoas em muitos assuntos. É ainda reconhecida como a raça que liderou os rebanhos dos exércitos romanos atravessando as montanhas alpinas e protegeu as pessoas da caravana.",
            petIMG = "",
            pedHash = "a_c_pug",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Femea",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },       
        {
            price = 1,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Poodle",
            petLabel = "O Rottweiler é uma das raças de cães mais antigas conhecidas,[1] que remonta ao Império Romano. Com suas características de pastoreio e guarda, eles têm ajudado as pessoas em muitos assuntos. É ainda reconhecida como a raça que liderou os rebanhos dos exércitos romanos atravessando as montanhas alpinas e protegeu as pessoas da caravana.",
            petIMG = "",
            pedHash = "a_c_poodle",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Femea",
            petLevel = 5,
            petBoughtAnim = false, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },     
        
        {
            price = 1,
            hungryRatio = 30, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 80, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 70, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 90, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
 
            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            petName = "Shepherd",
            petLabel = "A raça do cão pastor é uma das mais antigas raças de cães conhecidas,[1] que remonta ao Império Romano. Com suas características de pastoreio e guarda, eles têm ajudado as pessoas em muitos assuntos. É ainda reconhecida como a raça que conduziu os rebanhos dos exércitos romanos na travessia das montanhas alpinas e protegeu as pessoas da caravana.",
            petIMG = "",
            pedHash = "a_c_shepherd",
            petTexureID = 2, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Femea",
            petLevel = 5,
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },
        {
            price = 2,
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 5, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 5, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20
            
            petName = "Rootti",
            petLabel = "Canis é um gênero de mamíferos da família canina, que inclui cães, coiotes e a maioria dos lobos. As espécies deste gênero são caracterizadas por seu tamanho médio a grande, crânios e dentição grandes e bem desenvolvidos, pernas longas e orelhas e asas relativamente curtas.",
            petIMG = "",
            pedHash = "a_c_husky",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.
            petGender = "Macho",
            petLevel = 10,
            petBoughtAnim = true, -- With or without a purchase animation?
            listOf = "dog", -- which list to be on
        },    
        {
            price = 1,
            -- ped'i satın aldığınız zaman otomatik olarak gelecek olan değerler
            hungryRatio = 10, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            thirstRatio = 20, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            energyRatio = 50, --% When you buy the pet, it will directly indicate the health hunger value of the pet.
            healthRatio = 98, --% When you buy the pet, it will directly indicate the health hunger value of the pet.

            hungryDecrase = 1, -- When the pet is updated it will go " -1 ", example => Hunger level 40, "the number you specify" in the specified time interval - 40
            thirstDecrase = 1, -- When the pet is updated it will go " -1 ", example => Thirst level 20, At the set time interval "the number you specify" - 20

            petName = "Catty",
            petLabel = "Domestic cat, small, usually hairy, domesticated, carnivorous mammal. Usually kept as pets, they are called house cats, or simply cats if it is not necessary to distinguish them from other felines and small cats. People value the companionship of cats and their ability to hunt vermin and household pests.",
            petIMG = "",
            pedHash = "a_c_cat_01",
            petTexureID = 0, -- Pet TexureID > decides what color your pet will be so that it doesn't change color all the time or can have different colors.s
            petGender = "Macho",
            petBoughtAnim = true, -- With or without a purchase animation?
            petLevel = 10,
            listOf = "cat", -- which list to be on
        },  
    },
    --ORDER
    Orders = { -- In this section you can edit the orders that come directly to the pet, you can add different commands if you want.

        -- DOG
        {
            label = "SEGUIR",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:followOwner", -- In the 1st list of arguments that come with the content of the pet system, there is "Animal Type", i.e. cat or dog, and the 2nd argument is the networkID of the animal, so the first two functions will be filled with whatever you type here.
            level = 0, -- at what level it can be applied
        },
        {
            label = "SENTAR",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:sit",
            level = 0, -- at what level it can be applied
        },
        {
            label = "LEVANTAR",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:getup",
            level = 0, -- at what level it can be applied
        },
        {
            label = "DORMIR",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:sleep",
            level = 0, -- at what level it can be applied
        },
        {
            label = "ATAQUE",
            listOf = "dog", -- if he's a dog, his action
            args = "lab-pet:client:attack",
            level = 0, -- at what level it can be applied
        },

        --Cat 
        {
            label = "SEGUIR",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:followOwner",
            level = 0, -- at what level it can be applied
        },
        {
            label = "SENTAR",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:sit",
            level = 0, -- at what level it can be applied
        },
        {
            label = "GET UP",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getup",
            level = 0, -- at what level it can be applied
        },
        {
            label = "ENTRE NO CARRO",
            listOf = "dog", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getIntoCar",
            level = 0, -- at what level it can be applied
        },
        {
            label = "SAIA DO CARRO",
            listOf = "dog", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getOutCar",
            level = 0, -- at what level it can be applied
        },
        {
            label = "ENTRE NO CARRO",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getIntoCar",
            level = 0, -- at what level it can be applied
        },
        {
            label = "SAIA DO CARRO",
            listOf = "cat", -- eğer ki kedi ise yapacağı eylem
            args = "lab-pet:client:getOutCar",
            level = 0, -- at what level it can be applied
        },
    },
    OrderAnim = {
        ["dog"] = {
            ["sex"] = {
                animName = "creatures@rottweiler@amb@",
                animID = "hump_loop_chop" 
            },
            ["sit"] = {
                animName = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
                animID = "idle_b" 
            },
            ["bark"] = {
                animName = "creatures@rottweiler@amb@world_dog_barking@idle_a",
                animID = "idle_a" 
            },
            ["sleep"] = {
                animName = "creatures@rottweiler@amb@sleep_in_kennel@",
                animID = "sleep_in_kennel" 
            }, 
            ["getup"] = {
                animName = "creatures@rottweiler@amb@world_dog_sitting@exit",
                animID = "exit"
            }
            
        },
        ["cat"] = {
            ["sleep"] = {
                animName = "creatures@cat@amb@world_cat_sleeping_ground@base",
                animID = "base" 
            }, 
            ["getup"] = {
                animName = "creatures@cat@getup",
                animID = "getup_l" 
            },     
            ["sit"] = {
                animName = "creatures@cat@amb@world_cat_sleeping_ledge@base",
                animID = "base" 
            },       
        },
        -- ["bird"] = {
        --     {
        --         animName = "creatures@chickenhawk@amb@world_chickenhawk_feeding@base",
        --         animID = "base" 
        --     }, 
        --     {
        --         animName = "creatures@cormorant@amb@world_cormorant_standing@base",
        --         animID = "base" 
        --     },   
        -- }
    },
    
}
