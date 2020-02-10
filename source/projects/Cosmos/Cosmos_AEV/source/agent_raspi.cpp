/********************************************************************
* Copyright (C) 2015 by Interstel Technologies, Inc.
*   and Hawaii Space Flight Laboratory.
*
* This file is part of the COSMOS/core that is the central
* module for COSMOS. For more information on COSMOS go to
* <http://cosmos-project.com>
*
* The COSMOS/core software is licenced under the
* GNU Lesser General Public License (LGPL) version 3 licence.
*
* You should have received a copy of the
* GNU Lesser General Public License
* If not, go to <http://www.gnu.org/licenses/>
*
* COSMOS/core is free software: you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public License
* as published by the Free Software Foundation, either version 3 of
* the License, or (at your option) any later version.
*
* COSMOS/core is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* Refer to the "licences" folder for further information on the
* condititons and terms to use this software.
********************************************************************/

#include "support/configCosmos.h"
#include "agent/agentclass.h"
#include "device/serial/serialclass.h"
#include <iostream>
#include <fstream>
using namespace std;
Agent *agent;

/* COSMOS Agent for a Raspberry pi
 * runs with the temp.py Python script in the cosmos-arduino/python directory
 * Node: node-arduino
 * Agent: raspi
 * JSON data: "device_tsen_temp_000"
 */
int main(int argc, char** argv)
{
    cout << "Agent Arduino" << endl;
    Agent *agent;
    string nodename = "node-arduino";
    string agentname = "raspi"; //name of the agent that the request is directed to
    std::string soh;

    if(argc >1)
        agentname = argv[1];

    agent = new Agent(nodename, agentname);

    //Set SOH String
    // include all namespace names used - the names that are printed from the raspberry pi

     soh= "{\"node_loc_utc\","
                "\"node_loc_pos_eci\","
                "\"device_tsen_temp_000\"}" ;

    agent->set_sohstring(soh);

    ElapsedTime et;
    et.start();

    // set up pipe to read python script
    // python script returns json string to pipe
    std::string command("python ~/sensors/temp.py  2>&1");

    std::array<char, 128> buffer;
    std::string result;
    std::cout << "Opening reading pipe..." << std::endl;
    FILE* pipe = popen(command.c_str(), "r");
    if (!pipe)
    {
        std::cerr << "Couldn't start command." << std::endl;
        return 0;
    }
    std::cerr << "startinh temp.py. . ." << std::endl;




    // Start executing the agent
     while(agent->running())
    {

        int32_t status;
        string jsonstring;

        // read the buffer
        if(fgets(buffer.data(), 128, pipe) != NULL){
            jsonstring = buffer.data();
            // parse jsonstring and save data to the agent
            status = json_parse(jsonstring, agent->cinfo);

            // sanity check
            cout<<jsonstring<<endl;
        }


        //sleep for 1 sec
        COSMOS_SLEEP(0.1);
    }

    return 0;
}

