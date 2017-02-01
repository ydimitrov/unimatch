/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;

/**
 *
 * @author u01ydd14
 */
public class User {
    
    public int id;
    public String name, surname;
    public ArrayList<Interest> interests = new ArrayList<Interest>();
    
    public User(int id, String name, String surname) {
        this.id = id;
        this.name = name;
        this.surname = surname;
    }
    
    public void addInterest(Interest i) {
        this.interests.add(i);
    }
    
}