//
//  AnalyticsEvent.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/07/07.
//

import Foundation

enum AnalyticsEvent {
    
    enum Onboarding: String, AnalyticsEventProtocol {
        
        case viewOnboarding2 = "view_onboarding_2"
        case viewOnboarding3 = "view_onboarding_3"
        case viewOnboarding4 = "view_onboarding_4"
        case viewOnboarding5 = "view_onboarding_5"
        
        var name: String {
            return self.rawValue
        }
    }
    
    enum OnboardingClick: AnalyticsEventProtocol {
        case clickOnboardingStart
        case clickOnboardingNext2(select: String)
        case clickOnboardingNext3(select: [String])
        case clickOnboardingNext4
        case clickOnboardingNext5
        case clickPushAllow(section: Bool)
        case clickPushReject(section: Bool)
        case clickOnboardingNext6
                
        var name: String {
            switch self {
            case .clickOnboardingStart: return "click_onboarding_start"
            case .clickOnboardingNext2: return "click_onboarding_next_2"
            case .clickOnboardingNext3: return "click_onboarding_next_3"
            case .clickOnboardingNext4: return "click_onboarding_next_4"
            case .clickOnboardingNext5: return "click_onboarding_next_5"
            case .clickPushAllow: return "click_push_allow"
            case .clickPushReject: return "click_push_reject"
            case .clickOnboardingNext6: return "click_onboarding_next_6"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .clickOnboardingStart: return nil
            case .clickOnboardingNext2(select: let select): return ["onboard_select": select]
            case .clickOnboardingNext3(select: let select): return ["onboard_select": select]
            case .clickOnboardingNext4: return nil
            case .clickOnboardingNext5: return nil
            case .clickPushAllow(section: let section): return ["section": section]
            case .clickPushReject(section: let section): return ["section": section]
            case .clickOnboardingNext6: return nil
            }
        }
    }
    
    enum Login: AnalyticsEventProtocol {
        
        case viewSignIn
        case clickSignIn(provider: String)
        case completeSignIn(provider: String)
        case clickAdModalCta
        case clickAdModalClose(again: String)
        
        var name: String {
            switch self {
            case .viewSignIn: return "view_signin"
            case .clickSignIn: return  "click_signin"
            case .completeSignIn: return "complete_signin"
            case .clickAdModalCta: return "click_ad_modal_cta"
            case .clickAdModalClose: return "click_ad_modal_close"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewSignIn, .clickAdModalCta: return nil
            case .clickSignIn(provider: let provider ): return ["provider": provider]
            case .completeSignIn(provider: let provider): return ["provider": provider]
            case .clickAdModalClose(again: let again): return ["again": again]
            }
        }
    }
    
    enum Home: AnalyticsEventProtocol {
        case viewHome
        case clickReturnToday
        case clickWeeklyDate(date: String)
        case completeCheckMission(title: String, situation: String)
        case completeUncheckMission(title: String, situation: String)
        
        var name: String {
            switch self {
            case .viewHome: return "view_home"
            case .clickReturnToday: return "click_return_today"
            case .clickWeeklyDate: return "click_weekly_date"
            case .completeCheckMission: return "complete_check_mission"
            case .completeUncheckMission: return "complete_uncheck_mission"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewHome: return nil
            case .clickReturnToday: return nil
            case .clickWeeklyDate(date: let date): return ["date": date]
            case .completeCheckMission(title: let title, situation: let situation): return ["title": title, "situation": situation]
            case .completeUncheckMission(title: let title, situation: let situation): return ["title": title, "situation": situation]
            }
        }
    }
    
    enum Detail: AnalyticsEventProtocol {
        
        case appearDetailMission(title: String, situation: String, goal: String, action: [String])
        case closeDetailMission
        case clickDeleteMission(section: String, title: String, situation: String, goal: String, action: [String])
        case completeDeleteMission(section: String, title: String, situation: String, goal: String, action: [String])
        case clickEditMission(section: String)
        
        var name: String {
            switch self {
            case .appearDetailMission: return "appear_detail_mission"
            case .closeDetailMission: return "close_detail_mission"
            case .clickDeleteMission: return "click_delete_mission"
            case .completeDeleteMission: return "complete_delete_mission"
            case .clickEditMission: return "click_edit_mission"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .appearDetailMission(title: let title, situation: let situation, goal: let goal, action: let action): return ["title": title, "situation": situation, "goal": goal, "action": action]
            case .closeDetailMission: return nil
            case .clickDeleteMission(section: let section, title: let title, situation: let situation, goal: let goal, action: let action): return ["section": section, "title": title, "situation": situation, "goal": goal, "action": action]
            case .completeDeleteMission(section: let section, title: let title, situation: let situation, goal: let goal, action: let action): return ["section": section, "title": title, "situation": situation, "goal": goal, "action": action]
            case .clickEditMission(section: let section): return ["section": section]
                
            }
        }
    }
    
    enum SelectDate: AnalyticsEventProtocol {
        
        case appearAnotherDayModal
        case closeAnotherDayModal
        case completeAddMissionAnotherDay(title: String, situation: String, goal: String, action: [String], date: [String])
        case appearMaxedIssueMessage
        
        var name: String {
            switch self {
            case .appearAnotherDayModal: return "appear_another_day_modal"
            case .closeAnotherDayModal: return "close_another_day_modal"
            case .completeAddMissionAnotherDay: return "complete_add_mission_another_day"
            case .appearMaxedIssueMessage: return "appear_maxed_issue_message"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .appearAnotherDayModal: return nil
            case .closeAnotherDayModal: return nil
            case .completeAddMissionAnotherDay(title: let title, situation: let situation, goal: let goal, action: let action, date: let date): return ["title": title, "situation": situation, "goal": goal, "action": action, "date": date]
            case .appearMaxedIssueMessage: return nil
            }
        }
    }
    
    enum Achieve: AnalyticsEventProtocol {
        
        case appearDailyMissionModal(total: Int)
        case closeDailyMissionModal
        case viewAccomplish
        
        var name: String {
            switch self {
            case .appearDailyMissionModal: return "appear_daily_mission_modal"
            case .closeDailyMissionModal: return "close_daily_mission_modal"
            case .viewAccomplish: return "view_accomplish"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .appearDailyMissionModal(total: let total): return ["total_add_mission": total]
            case .closeDailyMissionModal: return nil
            case .viewAccomplish: return nil
            }
        }
    }
    
    enum MyInfo: String, AnalyticsEventProtocol {
        
        case viewMyInfo = "view_my_info"
        case clickMyInfo = "click_my_info"
        case clickGuide = "click_guide"
        case clickFaq = "click_faq"
        case clickNotice = "click_notice"
        case clickSuggestion = "click_suggestion"
        case clickQuestion = "click_question"
        case clickTerms = "click_terms"
        case clickOpenSource = "click_opensource"
        
        var name: String {
            return self.rawValue
        }
    }
    
    enum AccountInfo: String, AnalyticsEventProtocol {
        
        case viewAccountInfo = "view_account_info"
        case appearLogoutModal = "appear_logout_modal"
        case completeLogout = "complete_logout"
        case completePushOn = "complete_push_on"
        case completePushOff = "complete_push_off"
        case appearWithdrawalModal = "appear_withdrawal_modal"
        case completeWithdrawal = "complete_withdrawal"
        
        var name: String {
            return self.rawValue
        }
    }
    
    enum Recommend: AnalyticsEventProtocol {
        
        case viewRecommendMission
        case clickRecommendMission(situation: String, title: String)
        case clickSelfCreateMission
        
        var name: String {
            switch self {
            case .viewRecommendMission: return "view_recommend_mission"
            case .clickRecommendMission: return "click_recommend_mission"
            case .clickSelfCreateMission: return "click_self_create_mission"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewRecommendMission: return nil
            case .clickRecommendMission(situation: let situation, title: let title): return ["situation": situation, "title": title]
            case .clickSelfCreateMission: return nil
            }
        }
    }
    
    enum RecommendDetail: AnalyticsEventProtocol {
        
        case viewRecommendMissionDetail(situation: String, title: String)
        case clickCreateRecommendMission(action: String, situation: String, title: String)
        case clickSelfCreateAction
        
        var name: String {
            switch self {
            case .viewRecommendMissionDetail: return "view_recommend_mission_detail"
            case .clickCreateRecommendMission: return "click_create_recommend_mission"
            case .clickSelfCreateAction: return "click_self_create_action"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewRecommendMissionDetail(situation: let situation, title: let title): return ["situation": situation, "title": title]
            case .clickCreateRecommendMission(action: let action, situation: let situation, title: let title): return ["action": action, "situation": situation, "title": title]
            case .clickSelfCreateAction: return nil
            }
        }
    }
    
    enum CreateMission: AnalyticsEventProtocol {
        
        case viewCreateMission
        case clickCreateMission(date: [String], goal: String, title: String, situation: String, action: String)
        case completeCreateMission(date: [String], goal: String, title: String, situation: String, action: [String])
        
        var name: String {
            switch self {
            case .viewCreateMission: return "view_create_mission"
            case .clickCreateMission: return "click_create_mission"
            case .completeCreateMission: return "complete_create_mission"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewCreateMission: return nil
            case .clickCreateMission(date: let date, goal: let goal, title: let title, situation: let situation, action: let action):
                return ["date": date, "goal": goal, "title": title, "situation": situation, "action": action]
            case .completeCreateMission(date: let date, goal: let goal, title: let title, situation: let situation, action: let action):
                return ["date": date, "goal": goal, "title": title, "situation": situation, "action": action]
            }
        }
    }
    
    enum UpdateMission: AnalyticsEventProtocol {
        
        case viewUpdateMission(date: [String], goal: String, title: String, situation: String, action: String)
        case clickUpdateMission(date: [String], goal: String, title: String, situation: String, action: String)
        case completeUpdateMission(date: [String], goal: String, title: String, situation: String, action: String)
        
        var name: String {
            switch self {
            case .viewUpdateMission: return "view_update_mission"
            case .clickUpdateMission: return "click_update_mission"
            case .completeUpdateMission: return "complete_update_mission"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .viewUpdateMission(date: let date, goal: let goal, title: let title, situation: let situation, action: let action):
                return ["date": date, "goal": goal, "title": title, "situation": situation, "action": action]
            case .clickUpdateMission(date: let date, goal: let goal, title: let title, situation: let situation, action: let action):
                return ["date": date, "goal": goal, "title": title, "situation": situation, "action": action]
            case .completeUpdateMission(date: let date, goal: let goal, title: let title, situation: let situation, action: let action):
                return ["date": date, "goal": goal, "title": title, "situation": situation, "action": action]
            }
        }
    }
    
    enum CreateAndUpdateMissionCommon: AnalyticsEventProtocol {
        
        case clickMissionHistory(title: String)
        case clickRecommendSituation(situation: String)
        case appearSameMissionIssueMessage
        case appearMaxedIssueMessage
        
        var name: String {
            switch self {
            case .clickMissionHistory: return "click_mission_history"
            case .clickRecommendSituation: return "click_recommend_situation"
            case .appearSameMissionIssueMessage: return "appear_same_mission_issue_message"
            case .appearMaxedIssueMessage: return "appear_maxed_issue_message"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .clickMissionHistory(title: let title): return ["title": title]
            case .clickRecommendSituation(situation: let situation): return ["situation": situation]
            case .appearSameMissionIssueMessage: return nil
            case .appearMaxedIssueMessage: return nil
            }
        }
    }
}
