//
//  PexelsSwift+Orientation+Size.swift
//  
//
//  Created by Lukas Pistrol on 13.05.22.
//

import Foundation

public extension PexelsSwift {
    /// Supported orientations for search queries.
    enum PSOrientation: String {
        case landscape, portrait, square
    }

    /// Supported sizes for search queries.
    enum PSSize: String {
        case large, medium, small
    }

    /// Supported locales for search queries
    enum PSLocale: String {
        case en_US = "'en-US'"
        case pt_BR = "'pt-BR'"
        case es_ES = "'es-ES'"
        case ca_ES = "'ca-ES'"
        case de_DE = "'de-DE'"
        case it_IT = "'it-IT'"
        case fr_FR = "'fr-FR'"
        case sv_SE = "'sv-SE'"
        case id_ID = "'id-ID'"
        case pl_PL = "'pl-PL'"
        case ja_JP = "'ja-JP'"
        case zh_TW = "'zh-TW'"
        case zh_CN = "'zh-CN'"
        case ko_KR = "'ko-KR'"
        case th_TH = "'th-TH'"
        case nl_NL = "'nl-NL'"
        case hu_HU = "'hu-HU'"
        case vi_VN = "'vi-VN'"
        case cs_CZ = "'cs-CZ'"
        case da_DK = "'da-DK'"
        case fi_FI = "'fi-FI'"
        case uk_UA = "'uk-UA'"
        case ro_RO = "'ro-RO'"
        case nb_NO = "'nb-NO'"
        case sk_SK = "'sk-SK'"
        case tr_TR = "'tr-TR'"
        case ru_RU = "'ru-RU'"
    }
}
