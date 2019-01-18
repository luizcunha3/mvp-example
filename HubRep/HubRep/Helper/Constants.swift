//
//  Constants.swift
//  HubRep
//
//  Created by Tomaz Correa da Silva on 27/11/18.
//  Copyright © 2018 hubrep. All rights reserved.
//

import UIKit

public struct Constants {
    
    public struct Colors {
        public static let primaryColor = UIColor(colorHex: 0xE24329)
        public static let secondaryColor = UIColor(colorHex: 0xFC6D26)
        public static let cardShadowColor = UIColor(colorHex: 0x061F38, alpha: 0.08)
        public static let headerShadowColor = UIColor(colorHex: 0x061F38, alpha: 0.3)
    }
    
    public struct Segues {
        public static let repositories = "repositories"
        public static let repositoryDetail = "repositoryDetail"
    }
    
    public struct FindErrorType {
        public static let connectionError = "connectionError"
        public static let emptyResult = "emptyResult"
        public static let udefinedError = "emptyResult"
    }
    
    public struct FindErrorMessage {
        public static let connectionError = "Verifique a sua conexão com a internet! =("
        public static let emptyResult = "Nenhum repositório encontrado! =("
        public static let udefinedError = "Não foi possível realizar sua busca, tente novamente! =)"
    }
    
    public struct Cells {
        public static let repositoryTableViewCell = "RepositoryTableViewCell"
    }
}
