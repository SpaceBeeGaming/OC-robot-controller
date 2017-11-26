# OC_robot_commander
This set of scripts allows you to control an OpenComputers robot from OC computer using buttons. 
It is also possible to use easyish scripts to create action sequences. 

# DISCLAIMER:
This script isn't even done yet. You can currently move ~~only up and down.~~ in all directions (Have been busy working on the backend stuff.)

the buttonAPI is originally created by dw20 (minecraft youtuber) for ComputerCraft and ported by the guy in the link, 

so 99,9% of credists goes to him. https://oc.cil.li/index.php?/topic/255-button-api-now-for-oc-updated-9-6-2014/

BUT, i have updated it to include the additional feature made after it was ported. so the original demo in the link above won't work.

# To use:
1. download a copy of the repo and unzip it

2. Move files below to corresponding folders

                 "FILE:"                "WHERE"                "ON:"
                 
            "buttonAPI.lua"             "lib"                "computer"
            
            "Robot_Commander.lua"       "root"               "computer"
            
            "robot_Remote.lua"          "bin"                "computer"
            
            "robotLib.lua"              "root"               "robot"

3. navigate to "home" directory on the robot (boots here by default) type the command "edit .shrc" without quotes and add the following "/robotLib.lua" without quotes.

4. Ensure that both the computer and the robot have a linked card.

5. You'll have to use T3 server or a creative case. (by default you need T3 graphics card and the linked card is also T3)

6. Create an issue if you can't get it to work.

7. Pastebin links to come:

# Scripting
robot_Remote_Script.lua is a program that runs the script specified in arguments.

**You'll need to have the robot_Remote.lua and robotLib.lua like in the manual commader. also do step 3 of the usage instructions.**

the demoScript.txt file is a simple script.
###### Currently supported commands:

"move:<direction>"   direction ["F,B,L,R,A,U,D"] move/turn the robot to the direction specified, 

   if invalid direction gives response "move:NIL_done" >> Parsed by robot_Remote_Script.lua to user readable format.
  
"reboot" reboots the robot, if setup correctly it should start robotLib automatically.

"quit" quits the robotLib program.

"connected" simply sends back a confirmation that the robotLib is running.

If command vas invalid the robot vill give a "nil_command" response, which is parsed by robot_Remote_Script.lua to user readable format.

###### You can also run the script commands manually 
Typing "robot_Remote '-r' <one of the commands above>" without quotes.
  
-r is optional parameter that will wait for the response from the robot.
  
