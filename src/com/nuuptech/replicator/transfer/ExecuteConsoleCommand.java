/*
 * Copyright 2014 Nuuptech S.A. de C.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.nuuptech.replicator.transfer;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 *
 * @author Leonel Vazquez Jasso leonvj2.8@gmail.com
 */
public class ExecuteConsoleCommand {        

    /**
     * Default constructor with no args
     */
    public ExecuteConsoleCommand() {
    }
    
    public String ExecutingCommand(String command) {
        
        StringBuilder output = new StringBuilder();
        Process p;
        
        try {
            p = Runtime.getRuntime().exec(command);
            p.waitFor();
            BufferedReader reader;
            reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

            String line = "";
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
        } catch (IOException ex) {
            ex.printStackTrace();            
        } catch (InterruptedException ex) {
            ex.printStackTrace();            
        }
       
        return output.toString();
    }

}
