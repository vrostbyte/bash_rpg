#!/bin/bash

# Terminal RPG - A Complete Text-Based RPG Adventure
# Run with: bash rpg_game.sh

# Game configuration
SAVE_FILE="$HOME/.rpg_save.dat"
VERSION="1.0"

# Initialize colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Player stats
declare -A player
player[name]=""
player[class]=""
player[level]=1
player[exp]=0
player[exp_next]=100
player[hp]=100
player[max_hp]=100
player[mp]=20
player[max_mp]=20
player[attack]=10
player[defense]=5
player[speed]=5
player[gold]=50
player[location]="town"
player[weapon]="Rusty Sword"
player[armor]="Cloth Shirt"
player[accessory]="none"

# Inventory
declare -a inventory
inventory=("Health Potion" "Health Potion" "Mana Potion")

# Quest tracking
declare -A quests
quests[slime_hunter]=0
quests[goblin_menace]=0
quests[dragon_slayer]=0
quests[ancient_artifact]=0

# Weapons database
declare -A weapons
weapons["Rusty Sword"]=5
weapons["Iron Sword"]=12
weapons["Steel Sword"]=20
weapons["Silver Blade"]=35
weapons["Mythril Sword"]=50
weapons["Dragon Slayer"]=75
weapons["Excalibur"]=100

# Armor database
declare -A armors
armors["Cloth Shirt"]=2
armors["Leather Armor"]=8
armors["Iron Armor"]=15
armors["Steel Plate"]=25
armors["Mythril Armor"]=40
armors["Dragon Scale"]=60
armors["Divine Aegis"]=80

# Accessories database
declare -A accessories
accessories["Power Ring"]=10
accessories["Speed Boots"]=8
accessories["Guardian Amulet"]=12
accessories["Phoenix Feather"]=15
accessories["Crystal Pendant"]=20

# Items database with effects
declare -A items
items["Health Potion"]=50
items["Greater Health Potion"]=150
items["Mana Potion"]=30
items["Greater Mana Potion"]=80
items["Phoenix Down"]=999
items["Elixir"]=500

# Enemy database
declare -A enemies_hp enemies_attack enemies_defense enemies_exp enemies_gold
# Forest enemies
enemies_hp["Slime"]=30
enemies_attack["Slime"]=8
enemies_defense["Slime"]=2
enemies_exp["Slime"]=15
enemies_gold["Slime"]=10

enemies_hp["Wolf"]=50
enemies_attack["Wolf"]=15
enemies_defense["Wolf"]=5
enemies_exp["Wolf"]=25
enemies_gold["Wolf"]=20

enemies_hp["Goblin"]=60
enemies_attack["Goblin"]=18
enemies_defense["Goblin"]=8
enemies_exp["Goblin"]=35
enemies_gold["Goblin"]=30

# Cave enemies
enemies_hp["Bat"]=40
enemies_attack["Bat"]=12
enemies_defense["Bat"]=4
enemies_exp["Bat"]=20
enemies_gold["Bat"]=15

enemies_hp["Cave Spider"]=70
enemies_attack["Cave Spider"]=22
enemies_defense["Cave Spider"]=10
enemies_exp["Cave Spider"]=40
enemies_gold["Cave Spider"]=35

enemies_hp["Troll"]=120
enemies_attack["Troll"]=35
enemies_defense["Troll"]=15
enemies_exp["Troll"]=80
enemies_gold["Troll"]=60

# Mountain enemies
enemies_hp["Harpy"]=80
enemies_attack["Harpy"]=25
enemies_defense["Harpy"]=12
enemies_exp["Harpy"]=50
enemies_gold["Harpy"]=40

enemies_hp["Stone Golem"]=150
enemies_attack["Stone Golem"]=30
enemies_defense["Stone Golem"]=25
enemies_exp["Stone Golem"]=100
enemies_gold["Stone Golem"]=80

enemies_hp["Wyvern"]=200
enemies_attack["Wyvern"]=45
enemies_defense["Wyvern"]=20
enemies_exp["Wyvern"]=150
enemies_gold["Wyvern"]=120

# Dungeon enemies
enemies_hp["Skeleton"]=90
enemies_attack["Skeleton"]=28
enemies_defense["Skeleton"]=14
enemies_exp["Skeleton"]=60
enemies_gold["Skeleton"]=50

enemies_hp["Dark Knight"]=180
enemies_attack["Dark Knight"]=40
enemies_defense["Dark Knight"]=22
enemies_exp["Dark Knight"]=120
enemies_gold["Dark Knight"]=100

enemies_hp["Lich"]=250
enemies_attack["Lich"]=55
enemies_defense["Lich"]=18
enemies_exp["Lich"]=200
enemies_gold["Lich"]=150

# Boss enemies
enemies_hp["Goblin King"]=300
enemies_attack["Goblin King"]=50
enemies_defense["Goblin King"]=30
enemies_exp["Goblin King"]=500
enemies_gold["Goblin King"]=300

enemies_hp["Ancient Dragon"]=500
enemies_attack["Ancient Dragon"]=70
enemies_defense["Ancient Dragon"]=40
enemies_exp["Ancient Dragon"]=1000
enemies_gold["Ancient Dragon"]=500

enemies_hp["Demon Lord"]=800
enemies_attack["Demon Lord"]=90
enemies_defense["Demon Lord"]=50
enemies_exp["Demon Lord"]=2000
enemies_gold["Demon Lord"]=1000

# Utility functions
clear_screen() {
    clear
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           TERMINAL RPG - ${WHITE}v${VERSION}${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo
}

print_status() {
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC} ${WHITE}${player[name]}${NC} - ${YELLOW}${player[class]}${NC} - Level ${CYAN}${player[level]}${NC}"
    echo -e "${GREEN}║${NC} HP: ${RED}${player[hp]}/${player[max_hp]}${NC} | MP: ${BLUE}${player[mp]}/${player[max_mp]}${NC}"
    echo -e "${GREEN}║${NC} ATK: ${YELLOW}${player[attack]}${NC} | DEF: ${CYAN}${player[defense]}${NC} | SPD: ${PURPLE}${player[speed]}${NC}"
    echo -e "${GREEN}║${NC} Gold: ${YELLOW}${player[gold]}${NC} | EXP: ${WHITE}${player[exp]}/${player[exp_next]}${NC}"
    echo -e "${GREEN}║${NC} Location: ${CYAN}${player[location]}${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo
}

save_game() {
    {
        echo "VERSION=$VERSION"
        for key in "${!player[@]}"; do
            echo "player[$key]=${player[$key]}"
        done
        echo "inventory=(${inventory[@]})"
        for key in "${!quests[@]}"; do
            echo "quests[$key]=${quests[$key]}"
        done
    } > "$SAVE_FILE"
    echo -e "${GREEN}Game saved successfully!${NC}"
    sleep 1
}

load_game() {
    if [[ -f "$SAVE_FILE" ]]; then
        source "$SAVE_FILE"
        echo -e "${GREEN}Game loaded successfully!${NC}"
        sleep 1
        return 0
    else
        echo -e "${RED}No save file found!${NC}"
        sleep 1
        return 1
    fi
}

calculate_stats() {
    local base_attack=10
    local base_defense=5
    local base_speed=5
    
    # Class bonuses
    case ${player[class]} in
        "Warrior")
            base_attack=$((base_attack + 5))
            base_defense=$((base_defense + 3))
            ;;
        "Mage")
            player[max_mp]=$((player[max_mp] + 20))
            base_attack=$((base_attack + 2))
            ;;
        "Rogue")
            base_speed=$((base_speed + 5))
            base_attack=$((base_attack + 3))
            ;;
        "Paladin")
            base_defense=$((base_defense + 5))
            player[max_hp]=$((player[max_hp] + 20))
            ;;
    esac
    
    # Level bonuses
    base_attack=$((base_attack + (player[level] - 1) * 3))
    base_defense=$((base_defense + (player[level] - 1) * 2))
    base_speed=$((base_speed + (player[level] - 1) * 1))
    player[max_hp]=$((100 + (player[level] - 1) * 15))
    player[max_mp]=$((20 + (player[level] - 1) * 5))
    
    # Equipment bonuses
    player[attack]=$((base_attack + ${weapons[${player[weapon]}]:-0}))
    player[defense]=$((base_defense + ${armors[${player[armor]}]:-0}))
    
    # Accessory bonuses
    if [[ "${player[accessory]}" != "none" ]]; then
        case ${player[accessory]} in
            "Power Ring")
                player[attack]=$((player[attack] + ${accessories[${player[accessory]}]}))
                ;;
            "Speed Boots")
                player[speed]=$((base_speed + ${accessories[${player[accessory]}]}))
                ;;
            "Guardian Amulet")
                player[defense]=$((player[defense] + ${accessories[${player[accessory]}]}))
                ;;
            "Phoenix Feather")
                player[max_hp]=$((player[max_hp] + 50))
                ;;
            "Crystal Pendant")
                player[max_mp]=$((player[max_mp] + 30))
                ;;
        esac
    fi
}

level_up() {
    while [[ ${player[exp]} -ge ${player[exp_next]} ]]; do
        player[exp]=$((player[exp] - player[exp_next]))
        player[level]=$((player[level] + 1))
        player[exp_next]=$((player[exp_next] * 15 / 10))
        
        calculate_stats
        player[hp]=${player[max_hp]}
        player[mp]=${player[max_mp]}
        
        echo -e "${YELLOW}★ LEVEL UP! ★${NC}"
        echo -e "${GREEN}You are now level ${player[level]}!${NC}"
        echo -e "${CYAN}All stats increased!${NC}"
        echo -e "${RED}HP fully restored!${NC}"
        echo -e "${BLUE}MP fully restored!${NC}"
        sleep 2
    done
}

combat() {
    local enemy_name=$1
    local enemy_hp=${enemies_hp[$enemy_name]}
    local enemy_max_hp=$enemy_hp
    local enemy_attack=${enemies_attack[$enemy_name]}
    local enemy_defense=${enemies_defense[$enemy_name]}
    local turn=1
    
    clear_screen
    echo -e "${RED}⚔ BATTLE START! ⚔${NC}"
    echo -e "${YELLOW}A wild $enemy_name appears!${NC}"
    echo
    sleep 1
    
    while [[ ${player[hp]} -gt 0 && $enemy_hp -gt 0 ]]; do
        clear_screen
        echo -e "${RED}═══ BATTLE ═══${NC}"
        echo
        echo -e "${WHITE}${player[name]}${NC} HP: ${RED}${player[hp]}/${player[max_hp]}${NC} | MP: ${BLUE}${player[mp]}/${player[max_mp]}${NC}"
        echo -e "${YELLOW}$enemy_name${NC} HP: ${RED}$enemy_hp/$enemy_max_hp${NC}"
        echo
        echo -e "${GREEN}Turn $turn${NC}"
        echo
        echo "1) Attack"
        echo "2) Skills"
        echo "3) Items"
        echo "4) Flee"
        echo
        read -p "Choose action: " action
        
        case $action in
            1)
                # Player attacks
                local damage=$((player[attack] + RANDOM % 10 - enemy_defense / 2))
                if [[ $damage -lt 1 ]]; then damage=1; fi
                enemy_hp=$((enemy_hp - damage))
                echo -e "${GREEN}You deal $damage damage!${NC}"
                sleep 1
                ;;
            2)
                # Skills menu
                echo -e "${CYAN}Skills:${NC}"
                echo "1) Power Strike (10 MP) - 2x damage"
                echo "2) Heal (8 MP) - Restore 50 HP"
                echo "3) Barrier (5 MP) - +10 DEF for battle"
                echo "4) Cancel"
                read -p "Choose skill: " skill
                
                case $skill in
                    1)
                        if [[ ${player[mp]} -ge 10 ]]; then
                            player[mp]=$((player[mp] - 10))
                            local damage=$((player[attack] * 2 - enemy_defense / 2))
                            if [[ $damage -lt 1 ]]; then damage=1; fi
                            enemy_hp=$((enemy_hp - damage))
                            echo -e "${YELLOW}Power Strike! You deal $damage damage!${NC}"
                            sleep 1
                        else
                            echo -e "${RED}Not enough MP!${NC}"
                            sleep 1
                            continue
                        fi
                        ;;
                    2)
                        if [[ ${player[mp]} -ge 8 ]]; then
                            player[mp]=$((player[mp] - 8))
                            local heal=50
                            player[hp]=$((player[hp] + heal))
                            if [[ ${player[hp]} -gt ${player[max_hp]} ]]; then
                                player[hp]=${player[max_hp]}
                            fi
                            echo -e "${GREEN}You restored $heal HP!${NC}"
                            sleep 1
                        else
                            echo -e "${RED}Not enough MP!${NC}"
                            sleep 1
                            continue
                        fi
                        ;;
                    3)
                        if [[ ${player[mp]} -ge 5 ]]; then
                            player[mp]=$((player[mp] - 5))
                            player[defense]=$((player[defense] + 10))
                            echo -e "${CYAN}Defense increased by 10!${NC}"
                            sleep 1
                        else
                            echo -e "${RED}Not enough MP!${NC}"
                            sleep 1
                            continue
                        fi
                        ;;
                    4)
                        continue
                        ;;
                esac
                ;;
            3)
                # Items menu
                echo -e "${CYAN}Items:${NC}"
                local i=1
                for item in "${inventory[@]}"; do
                    echo "$i) $item"
                    ((i++))
                done
                echo "$i) Cancel"
                read -p "Choose item: " item_choice
                
                if [[ $item_choice -eq $i ]]; then
                    continue
                elif [[ $item_choice -gt 0 && $item_choice -lt $i ]]; then
                    local item_index=$((item_choice - 1))
                    local used_item="${inventory[$item_index]}"
                    
                    case $used_item in
                        *"Health Potion"*)
                            local heal_amount=${items[$used_item]}
                            player[hp]=$((player[hp] + heal_amount))
                            if [[ ${player[hp]} -gt ${player[max_hp]} ]]; then
                                player[hp]=${player[max_hp]}
                            fi
                            echo -e "${GREEN}You restored $heal_amount HP!${NC}"
                            unset 'inventory[$item_index]'
                            inventory=("${inventory[@]}")
                            sleep 1
                            ;;
                        *"Mana Potion"*)
                            local mana_amount=${items[$used_item]}
                            player[mp]=$((player[mp] + mana_amount))
                            if [[ ${player[mp]} -gt ${player[max_mp]} ]]; then
                                player[mp]=${player[max_mp]}
                            fi
                            echo -e "${BLUE}You restored $mana_amount MP!${NC}"
                            unset 'inventory[$item_index]'
                            inventory=("${inventory[@]}")
                            sleep 1
                            ;;
                        "Elixir")
                            player[hp]=${player[max_hp]}
                            player[mp]=${player[max_mp]}
                            echo -e "${YELLOW}Fully restored HP and MP!${NC}"
                            unset 'inventory[$item_index]'
                            inventory=("${inventory[@]}")
                            sleep 1
                            ;;
                    esac
                else
                    continue
                fi
                ;;
            4)
                # Flee
                if [[ $((RANDOM % 100)) -lt 50 ]]; then
                    echo -e "${YELLOW}You fled successfully!${NC}"
                    sleep 1
                    return 2
                else
                    echo -e "${RED}Couldn't escape!${NC}"
                    sleep 1
                fi
                ;;
            *)
                continue
                ;;
        esac
        
        # Enemy turn
        if [[ $enemy_hp -gt 0 ]]; then
            local enemy_damage=$((enemy_attack + RANDOM % 10 - player[defense] / 2))
            if [[ $enemy_damage -lt 1 ]]; then enemy_damage=1; fi
            player[hp]=$((player[hp] - enemy_damage))
            echo -e "${RED}$enemy_name deals $enemy_damage damage!${NC}"
            sleep 1
        fi
        
        ((turn++))
    done
    
    if [[ ${player[hp]} -le 0 ]]; then
        echo -e "${RED}You have been defeated...${NC}"
        echo -e "${YELLOW}You lose half your gold.${NC}"
        player[gold]=$((player[gold] / 2))
        player[hp]=1
        player[location]="town"
        sleep 3
        return 1
    else
        local exp_gain=${enemies_exp[$enemy_name]}
        local gold_gain=${enemies_gold[$enemy_name]}
        
        echo -e "${GREEN}Victory!${NC}"
        echo -e "${YELLOW}Gained $exp_gain EXP!${NC}"
        echo -e "${YELLOW}Gained $gold_gain Gold!${NC}"
        
        player[exp]=$((player[exp] + exp_gain))
        player[gold]=$((player[gold] + gold_gain))
        
        # Random item drop
        if [[ $((RANDOM % 100)) -lt 30 ]]; then
            local drops=("Health Potion" "Mana Potion" "Health Potion" "Greater Health Potion")
            local drop=${drops[$((RANDOM % ${#drops[@]}))]}
            inventory+=("$drop")
            echo -e "${CYAN}Found: $drop!${NC}"
        fi
        
        # Quest tracking
        case $enemy_name in
            "Slime")
                quests[slime_hunter]=$((quests[slime_hunter] + 1))
                ;;
            "Goblin")
                quests[goblin_menace]=$((quests[goblin_menace] + 1))
                ;;
            "Ancient Dragon")
                quests[dragon_slayer]=1
                ;;
        esac
        
        sleep 2
        level_up
        return 0
    fi
}

shop_menu() {
    while true; do
        clear_screen
        print_status
        echo -e "${YELLOW}═══ SHOP ═══${NC}"
        echo
        echo "1) Weapons"
        echo "2) Armor"
        echo "3) Accessories"
        echo "4) Items"
        echo "5) Sell Items"
        echo "6) Leave Shop"
        echo
        read -p "Choose category: " choice
        
        case $choice in
            1)
                echo -e "${CYAN}Weapons:${NC}"
                echo "1) Iron Sword - 200g (ATK +12)"
                echo "2) Steel Sword - 500g (ATK +20)"
                echo "3) Silver Blade - 1000g (ATK +35)"
                echo "4) Mythril Sword - 2000g (ATK +50)"
                echo "5) Cancel"
                read -p "Choose weapon: " weapon_choice
                
                case $weapon_choice in
                    1)
                        if [[ ${player[gold]} -ge 200 ]]; then
                            player[gold]=$((player[gold] - 200))
                            player[weapon]="Iron Sword"
                            calculate_stats
                            echo -e "${GREEN}Purchased Iron Sword!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    2)
                        if [[ ${player[gold]} -ge 500 ]]; then
                            player[gold]=$((player[gold] - 500))
                            player[weapon]="Steel Sword"
                            calculate_stats
                            echo -e "${GREEN}Purchased Steel Sword!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    3)
                        if [[ ${player[gold]} -ge 1000 ]]; then
                            player[gold]=$((player[gold] - 1000))
                            player[weapon]="Silver Blade"
                            calculate_stats
                            echo -e "${GREEN}Purchased Silver Blade!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    4)
                        if [[ ${player[gold]} -ge 2000 ]]; then
                            player[gold]=$((player[gold] - 2000))
                            player[weapon]="Mythril Sword"
                            calculate_stats
                            echo -e "${GREEN}Purchased Mythril Sword!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                esac
                sleep 1
                ;;
            2)
                echo -e "${CYAN}Armor:${NC}"
                echo "1) Leather Armor - 150g (DEF +8)"
                echo "2) Iron Armor - 400g (DEF +15)"
                echo "3) Steel Plate - 800g (DEF +25)"
                echo "4) Mythril Armor - 1500g (DEF +40)"
                echo "5) Cancel"
                read -p "Choose armor: " armor_choice
                
                case $armor_choice in
                    1)
                        if [[ ${player[gold]} -ge 150 ]]; then
                            player[gold]=$((player[gold] - 150))
                            player[armor]="Leather Armor"
                            calculate_stats
                            echo -e "${GREEN}Purchased Leather Armor!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    2)
                        if [[ ${player[gold]} -ge 400 ]]; then
                            player[gold]=$((player[gold] - 400))
                            player[armor]="Iron Armor"
                            calculate_stats
                            echo -e "${GREEN}Purchased Iron Armor!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    3)
                        if [[ ${player[gold]} -ge 800 ]]; then
                            player[gold]=$((player[gold] - 800))
                            player[armor]="Steel Plate"
                            calculate_stats
                            echo -e "${GREEN}Purchased Steel Plate!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    4)
                        if [[ ${player[gold]} -ge 1500 ]]; then
                            player[gold]=$((player[gold] - 1500))
                            player[armor]="Mythril Armor"
                            calculate_stats
                            echo -e "${GREEN}Purchased Mythril Armor!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                esac
                sleep 1
                ;;
            3)
                echo -e "${CYAN}Accessories:${NC}"
                echo "1) Power Ring - 300g (+10 ATK)"
                echo "2) Speed Boots - 250g (+8 SPD)"
                echo "3) Guardian Amulet - 400g (+12 DEF)"
                echo "4) Phoenix Feather - 600g (+50 HP)"
                echo "5) Crystal Pendant - 500g (+30 MP)"
                echo "6) Cancel"
                read -p "Choose accessory: " acc_choice
                
                case $acc_choice in
                    1)
                        if [[ ${player[gold]} -ge 300 ]]; then
                            player[gold]=$((player[gold] - 300))
                            player[accessory]="Power Ring"
                            calculate_stats
                            echo -e "${GREEN}Purchased Power Ring!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    2)
                        if [[ ${player[gold]} -ge 250 ]]; then
                            player[gold]=$((player[gold] - 250))
                            player[accessory]="Speed Boots"
                            calculate_stats
                            echo -e "${GREEN}Purchased Speed Boots!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    3)
                        if [[ ${player[gold]} -ge 400 ]]; then
                            player[gold]=$((player[gold] - 400))
                            player[accessory]="Guardian Amulet"
                            calculate_stats
                            echo -e "${GREEN}Purchased Guardian Amulet!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    4)
                        if [[ ${player[gold]} -ge 600 ]]; then
                            player[gold]=$((player[gold] - 600))
                            player[accessory]="Phoenix Feather"
                            calculate_stats
                            echo -e "${GREEN}Purchased Phoenix Feather!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    5)
                        if [[ ${player[gold]} -ge 500 ]]; then
                            player[gold]=$((player[gold] - 500))
                            player[accessory]="Crystal Pendant"
                            calculate_stats
                            echo -e "${GREEN}Purchased Crystal Pendant!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                esac
                sleep 1
                ;;
            4)
                echo -e "${CYAN}Items:${NC}"
                echo "1) Health Potion - 50g"
                echo "2) Greater Health Potion - 150g"
                echo "3) Mana Potion - 30g"
                echo "4) Greater Mana Potion - 100g"
                echo "5) Elixir - 500g"
                echo "6) Cancel"
                read -p "Choose item: " item_choice
                
                case $item_choice in
                    1)
                        if [[ ${player[gold]} -ge 50 ]]; then
                            player[gold]=$((player[gold] - 50))
                            inventory+=("Health Potion")
                            echo -e "${GREEN}Purchased Health Potion!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    2)
                        if [[ ${player[gold]} -ge 150 ]]; then
                            player[gold]=$((player[gold] - 150))
                            inventory+=("Greater Health Potion")
                            echo -e "${GREEN}Purchased Greater Health Potion!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    3)
                        if [[ ${player[gold]} -ge 30 ]]; then
                            player[gold]=$((player[gold] - 30))
                            inventory+=("Mana Potion")
                            echo -e "${GREEN}Purchased Mana Potion!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    4)
                        if [[ ${player[gold]} -ge 100 ]]; then
                            player[gold]=$((player[gold] - 100))
                            inventory+=("Greater Mana Potion")
                            echo -e "${GREEN}Purchased Greater Mana Potion!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                    5)
                        if [[ ${player[gold]} -ge 500 ]]; then
                            player[gold]=$((player[gold] - 500))
                            inventory+=("Elixir")
                            echo -e "${GREEN}Purchased Elixir!${NC}"
                        else
                            echo -e "${RED}Not enough gold!${NC}"
                        fi
                        ;;
                esac
                sleep 1
                ;;
            5)
                echo -e "${CYAN}Your Inventory:${NC}"
                local i=1
                for item in "${inventory[@]}"; do
                    echo "$i) $item - Sell for 25g"
                    ((i++))
                done
                echo "$i) Cancel"
                read -p "Choose item to sell: " sell_choice
                
                if [[ $sell_choice -eq $i ]]; then
                    continue
                elif [[ $sell_choice -gt 0 && $sell_choice -lt $i ]]; then
                    local sell_index=$((sell_choice - 1))
                    local sold_item="${inventory[$sell_index]}"
                    unset 'inventory[$sell_index]'
                    inventory=("${inventory[@]}")
                    player[gold]=$((player[gold] + 25))
                    echo -e "${GREEN}Sold $sold_item for 25g!${NC}"
                    sleep 1
                fi
                ;;
            6)
                return
                ;;
        esac
    done
}

inn_menu() {
    clear_screen
    print_status
    echo -e "${CYAN}═══ INN ═══${NC}"
    echo
    echo -e "${GREEN}Welcome to the inn!${NC}"
    echo "Rest here to restore your HP and MP."
    echo "Cost: 30 Gold"
    echo
    echo "1) Rest (30g)"
    echo "2) Leave"
    echo
    read -p "Choose option: " choice
    
    case $choice in
        1)
            if [[ ${player[gold]} -ge 30 ]]; then
                player[gold]=$((player[gold] - 30))
                player[hp]=${player[max_hp]}
                player[mp]=${player[max_mp]}
                echo -e "${GREEN}You feel refreshed!${NC}"
                echo -e "${RED}HP fully restored!${NC}"
                echo -e "${BLUE}MP fully restored!${NC}"
                save_game
                sleep 2
            else
                echo -e "${RED}Not enough gold!${NC}"
                sleep 1
            fi
            ;;
    esac
}

quest_board() {
    clear_screen
    print_status
    echo -e "${YELLOW}═══ QUEST BOARD ═══${NC}"
    echo
    echo -e "${CYAN}Active Quests:${NC}"
    echo
    
    # Slime Hunter Quest
    if [[ ${quests[slime_hunter]} -lt 10 ]]; then
        echo -e "${WHITE}1) Slime Hunter${NC}"
        echo "   Defeat 10 Slimes"
        echo "   Progress: ${quests[slime_hunter]}/10"
        echo "   Reward: 200 Gold, Greater Health Potion"
    else
        echo -e "${GREEN}1) Slime Hunter - COMPLETED${NC}"
    fi
    echo
    
    # Goblin Menace Quest
    if [[ ${quests[goblin_menace]} -lt 5 ]]; then
        echo -e "${WHITE}2) Goblin Menace${NC}"
        echo "   Defeat 5 Goblins"
        echo "   Progress: ${quests[goblin_menace]}/5"
        echo "   Reward: 500 Gold, Iron Sword"
    else
        echo -e "${GREEN}2) Goblin Menace - COMPLETED${NC}"
    fi
    echo
    
    # Dragon Slayer Quest
    if [[ ${quests[dragon_slayer]} -eq 0 ]]; then
        echo -e "${PURPLE}3) Dragon Slayer (LEGENDARY)${NC}"
        echo "   Defeat the Ancient Dragon"
        echo "   Progress: Not Started"
        echo "   Reward: 2000 Gold, Dragon Slayer Sword"
    else
        echo -e "${YELLOW}3) Dragon Slayer - COMPLETED${NC}"
    fi
    echo
    
    echo "4) Claim Rewards"
    echo "5) Back"
    echo
    read -p "Choose option: " choice
    
    case $choice in
        4)
            # Claim rewards
            if [[ ${quests[slime_hunter]} -ge 10 ]]; then
                quests[slime_hunter]=-1
                player[gold]=$((player[gold] + 200))
                inventory+=("Greater Health Potion")
                echo -e "${GREEN}Slime Hunter rewards claimed!${NC}"
                sleep 1
            fi
            
            if [[ ${quests[goblin_menace]} -ge 5 ]]; then
                quests[goblin_menace]=-1
                player[gold]=$((player[gold] + 500))
                player[weapon]="Iron Sword"
                calculate_stats
                echo -e "${GREEN}Goblin Menace rewards claimed!${NC}"
                sleep 1
            fi
            
            if [[ ${quests[dragon_slayer]} -eq 1 ]]; then
                quests[dragon_slayer]=-1
                player[gold]=$((player[gold] + 2000))
                player[weapon]="Dragon Slayer"
                calculate_stats
                echo -e "${YELLOW}Dragon Slayer rewards claimed!${NC}"
                sleep 1
            fi
            ;;
    esac
}

town_menu() {
    while true; do
        clear_screen
        print_status
        echo -e "${CYAN}═══ TOWN ═══${NC}"
        echo
        echo "1) Shop"
        echo "2) Inn"
        echo "3) Quest Board"
        echo "4) Explore"
        echo "5) Inventory"
        echo "6) Save Game"
        echo "7) Quit"
        echo
        read -p "Choose action: " choice
        
        case $choice in
            1) shop_menu ;;
            2) inn_menu ;;
            3) quest_board ;;
            4)
                echo -e "${GREEN}Where would you like to go?${NC}"
                echo "1) Forest (Level 1-5)"
                echo "2) Cave (Level 5-10)"
                echo "3) Mountain (Level 10-15)"
                echo "4) Dungeon (Level 15-20)"
                echo "5) Cancel"
                read -p "Choose destination: " dest
                
                case $dest in
                    1) player[location]="forest"; return ;;
                    2) player[location]="cave"; return ;;
                    3) player[location]="mountain"; return ;;
                    4) player[location]="dungeon"; return ;;
                esac
                ;;
            5)
                clear_screen
                print_status
                echo -e "${CYAN}═══ INVENTORY ═══${NC}"
                echo
                echo -e "${YELLOW}Equipment:${NC}"
                echo "Weapon: ${player[weapon]}"
                echo "Armor: ${player[armor]}"
                echo "Accessory: ${player[accessory]}"
                echo
                echo -e "${CYAN}Items:${NC}"
                for item in "${inventory[@]}"; do
                    echo "- $item"
                done
                echo
                read -p "Press Enter to continue..."
                ;;
            6) save_game ;;
            7)
                echo -e "${YELLOW}Thanks for playing!${NC}"
                exit 0
                ;;
        esac
    done
}

explore_area() {
    local area=${player[location]}
    local enemies=()
    
    case $area in
        "forest")
            enemies=("Slime" "Slime" "Wolf" "Goblin")
            ;;
        "cave")
            enemies=("Bat" "Cave Spider" "Cave Spider" "Troll")
            ;;
        "mountain")
            enemies=("Harpy" "Stone Golem" "Wyvern")
            ;;
        "dungeon")
            enemies=("Skeleton" "Dark Knight" "Lich")
            ;;
    esac
    
    while true; do
        clear_screen
        print_status
        echo -e "${PURPLE}═══ ${area^^} ═══${NC}"
        echo
        echo "1) Search for enemies"
        echo "2) Look for treasure"
        echo "3) Rest (Restore 20 HP/10 MP)"
        echo "4) Return to town"
        echo
        read -p "Choose action: " choice
        
        case $choice in
            1)
                local enemy=${enemies[$((RANDOM % ${#enemies[@]}))]}
                echo -e "${YELLOW}Searching...${NC}"
                sleep 1
                combat "$enemy"
                ;;
            2)
                echo -e "${CYAN}Searching for treasure...${NC}"
                sleep 1
                if [[ $((RANDOM % 100)) -lt 30 ]]; then
                    local found_gold=$((RANDOM % 50 + 20))
                    player[gold]=$((player[gold] + found_gold))
                    echo -e "${GREEN}Found $found_gold gold!${NC}"
                elif [[ $((RANDOM % 100)) -lt 20 ]]; then
                    local treasures=("Health Potion" "Mana Potion" "Greater Health Potion")
                    local treasure=${treasures[$((RANDOM % ${#treasures[@]}))]}
                    inventory+=("$treasure")
                    echo -e "${GREEN}Found: $treasure!${NC}"
                else
                    echo -e "${WHITE}Nothing found...${NC}"
                fi
                sleep 2
                ;;
            3)
                player[hp]=$((player[hp] + 20))
                if [[ ${player[hp]} -gt ${player[max_hp]} ]]; then
                    player[hp]=${player[max_hp]}
                fi
                player[mp]=$((player[mp] + 10))
                if [[ ${player[mp]} -gt ${player[max_mp]} ]]; then
                    player[mp]=${player[max_mp]}
                fi
                echo -e "${GREEN}You rest and recover some HP and MP.${NC}"
                sleep 1
                ;;
            4)
                player[location]="town"
                return
                ;;
        esac
        
        # Random boss encounter
        if [[ $((RANDOM % 100)) -lt 5 ]]; then
            echo -e "${RED}A powerful presence appears!${NC}"
            sleep 1
            case $area in
                "forest")
                    combat "Goblin King"
                    ;;
                "mountain")
                    combat "Ancient Dragon"
                    ;;
                "dungeon")
                    combat "Demon Lord"
                    ;;
            esac
        fi
    done
}

character_creation() {
    clear_screen
    echo -e "${YELLOW}═══ CHARACTER CREATION ═══${NC}"
    echo
    read -p "Enter your character's name: " name
    player[name]=$name
    
    echo
    echo -e "${CYAN}Choose your class:${NC}"
    echo "1) Warrior - High HP and Defense"
    echo "2) Mage - High MP and Magic Power"
    echo "3) Rogue - High Speed and Critical Chance"
    echo "4) Paladin - Balanced with Healing Skills"
    echo
    read -p "Choose class: " class_choice
    
    case $class_choice in
        1) player[class]="Warrior" ;;
        2) player[class]="Mage" ;;
        3) player[class]="Rogue" ;;
        4) player[class]="Paladin" ;;
        *) player[class]="Warrior" ;;
    esac
    
    calculate_stats
    player[hp]=${player[max_hp]}
    player[mp]=${player[max_mp]}
}

main_menu() {
    clear_screen
    echo -e "${YELLOW}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}         ${CYAN}TERMINAL RPG ADVENTURE${NC}         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}            ${WHITE}Version ${VERSION}${NC}              ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════╝${NC}"
    echo
    echo "1) New Game"
    echo "2) Continue"
    echo "3) About"
    echo "4) Quit"
    echo
    read -p "Choose option: " choice
    
    case $choice in
        1)
            character_creation
            echo
            echo -e "${GREEN}Welcome to the world of Terminal RPG, ${player[name]}!${NC}"
            echo -e "${CYAN}Your adventure begins in the town square...${NC}"
            sleep 3
            ;;
        2)
            if ! load_game; then
                echo -e "${YELLOW}Starting new game instead...${NC}"
                sleep 1
                character_creation
            fi
            ;;
        3)
            clear_screen
            echo -e "${CYAN}═══ ABOUT ═══${NC}"
            echo
            echo "Terminal RPG - A Complete Text-Based Adventure"
            echo "Version: $VERSION"
            echo
            echo "Features:"
            echo "- Multiple character classes"
            echo "- Turn-based combat system"
            echo "- Leveling and skill progression"
            echo "- Equipment and inventory management"
            echo "- Quest system"
            echo "- Multiple exploration areas"
            echo "- Save/Load functionality"
            echo "- 15+ enemy types including bosses"
            echo
            echo "Created in pure Bash"
            echo
            read -p "Press Enter to continue..."
            main_menu
            ;;
        4)
            echo -e "${YELLOW}Thanks for playing!${NC}"
            exit 0
            ;;
        *)
            main_menu
            ;;
    esac
}

# Main game loop
main_menu

while true; do
    case ${player[location]} in
        "town")
            town_menu
            ;;
        *)
            explore_area
            ;;
    esac
done
