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
//#define NUM_DATA 2
using namespace std;
Agent *agent;
ofstream file;



// use: agent_arduino <agent_name> <device path> <sensor number(ex: 000,001,...)>
int main(int argc, char** argv)
{
    cout << "Agent Arduino" << endl;
    Agent *agent;
    string nodename = "node-arduino";
    string agentname = "arduino"; //name of the agent that the request is directed to
    std::string soh;



    // if there is no arguments use default serial port
    string serial_port = "/dev/ttyACM0";
    size_t serial_baud = 9600;
    string sensor_num = "000";

    if(argc >1)
        agentname = argv[1];
    if (argc >2) {
        serial_port = argv[2];
    }
    if(argc >3){
        sensor_num = argv[3];
    }
    agent = new Agent(nodename, agentname);

    //Set SOH String
    // include all namespace names used - the names that are printed from the arduino serial port

     soh= "{\"node_loc_utc\","
                "\"node_loc_pos_eci\","
                "\"device_tsen_temp_"+sensor_num+"\"}" ;

    agent->set_sohstring(soh);

    ElapsedTime et;
    et.start();

    // set up reading from serial port
    Serial serial_arduino = Serial(serial_port,serial_baud);
    serial_arduino.set_timeout(0, 3.);

    cout << "serial port: " << serial_port << " at " << serial_baud << endl;
    if (serial_arduino.get_error() < 0) {
        // there was error opening the serial port, close the program
        cout << "error opening serial port: " << serial_arduino.get_error()  << endl;
        return 0;
    }


    // Start executing the agent
     while(agent->running())
    {

        int32_t status;
        string jsonstring;

        // read serial port from the arduino
        // reads the first line and saves it in jsonstring
        status = serial_arduino.get_string(jsonstring, '\n');
        if(status > 0){

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

