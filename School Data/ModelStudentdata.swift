//
//  ModelStudentdata.swift
//  FirebaseDataSaveDemo
//
//  Created by Skycap on 05/09/22.
//

import Foundation
class StudentDataModel{
    var name: String?
    var age: Int?
    var profileImageURL: String?
    var address: String?
    var stu_class: String?
    var first_name :  String?
    var last_name: String?
    init(name: String, age: Int, profileImageURL: String, address: String,stu_class : String,first_name: String, last_name : String){
        self.name = name
        self.age = age
        self.profileImageURL = profileImageURL
        self.address = address
        self.stu_class = stu_class
        self.first_name = first_name
        self.last_name = last_name
    }
}
