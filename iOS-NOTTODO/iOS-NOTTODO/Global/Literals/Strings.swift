//
//  Strings.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

struct I18N {
    
    /// Auth
    
    static let loginMain = """
                        이제 오늘의 낫투두를 세우고
                        변화된 삶을 느껴보세요!
                        """
    static let loginSub = """
                        계정을 연동하면
                        안전하게 데이터를 보관하고
                        어디서든 낫투두 기록을 관리할 수 있어요.
                        """
    static let kakaoLogin = "카카오 로그인"
    static let appleLogin = "Apple로 로그인"
    static let moreAuth = "이용약관 및 개인정보 처리방침"
    static let condition = "이용약관"
    static let personalInfo = "개인정보 처리방침"
    static let moreLink = "https://teamnottodo.notion.site/0c3c7c02857b46e1b16307ce7a8f6ca9"
    
    /// Recommend
    
    static let recommendNavTitle = "낫투두 생성"
    static let addAction = "직접 입력하러 가기"
    
    /// RecommendAction
    
    static let recommendAction = "실천방법 추천"
    static let recommendActionSub = "아래 추천 항목을 선택해 실천방법을 추가하세요"
    static let more = "필요 없어요 or 직접 입력할게요!"
    static let next = "계속하기"
    
    /// Home Empty
    
    static let emptyTitle = "새로운 낫투두를 추가하고\n목표 달성을 위한 환경을 만들어보세요!"
    static let todayButton = "오늘"
    static let yearMonthTitle = "YYYY년 MM월"
    static let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    
    /// Achievement
    
    static let achievement = "성취"
    static let total = "<매달 낫투두 성취 공유하고 선물받자!>\n인스타 @nottodo_official을 확인해주세요 :)"
    
    /// Detail
    
    static let detailEdit = "편집"
    static let detailAction = "실천 행동"
    static let detailGoal = "목표"
    static let detailDate = "다른 날도 할래요"
    static let detailSelect = "날짜 선택"
    static let detailDelete = "삭제하기"
    static let detailComplete = "완료"
    
    /// AddMission
    
    static let add = "추가"
    static let date = "날짜"
    static let nottodo = "낫투두"
    static let situation = "상황"
    static let doAction = "실천방법"
    static let goal = "목표"
    static let action = "방법"
    static let subDateTitle = "언제 낫투두를 실천할까요?"
    static let subNottodo = "어떤 낫투두를 실천할까요?"
    static let nottodoPlaceholder = "낫투두는 ‘~않기'로 작성하면 더 쉬워요."
    static let subSituation = """
                            위 낫투두를
                            어떤 상황에서 실천할까요?
                            """
    static let subAction = """
                        어떤 방법으로
                        낫투두에 도전할까요?
                        """
    static let subGoal = """
                        낫투두를 통해서
                        어떤 목표를 이루려 하나요?
                        """
    static let missionHistoryLabel = "낫투두 입력 기록"
    static let recommendKeyword = "추천 상황"
    static let example = "예시)"
    static let exampleNottodo = "낫투두 - 유튜브 보지 않기"
    static let exampleAction1 = "실천방법 - 유튜브 프리미엄 구독 취소"
    static let exampleAction2 = "실천방법 - 공부 중에 가방 안에 핸드폰 넣기"
    static let exampleGoalNottodo = "운동 중 20분 이상 쉬지 않기"
    static let exampleGoal = "근손실 막고 근육량 늘리기"
    static let dateWarning = "*달성 가능한 계획을 위해 다가올 일주일만 선택할 수 있어요"
    static let tipMessage = """
                          실천방법과 목표를 입력하면
                          낫투두 성공 확률이 더욱 올라가요!
                          """
    static let enterMessage = "입력하세요..."
    static let option = "*선택"
    static let today = "오늘"
    static let tomorrow = "내일"
    static let finish = "완료"
    static let updateTitle = "낫투두 수정"
    
    /// MyInfo

    static let myInfo = "내 정보"
    
    /// MyInfoAccount
    
    static let myInfoAccount = "계정 정보"
    static let nickname = "유저명"
    static let email = "이메일"
    static let account = "연결된 계정"
    static let notification = "푸시 알림 설정"
    static let logout = "로그아웃"
    static let withdraw = "회원 탈퇴"
    static let logoutAlertTitle = "로그아웃 하시겠습니까?"
    static let logoutAlertmessage = "로그아웃을 하면\n다른 기기와 낫투두 기록을 연동하지 못해요."
    
    /// Onboarding
    
    static let firstOnboarding = "남들과는 다르게\n일상 속 나만의 규율로\n더 나은 삶을 만들어볼까요?"
    static let secondOnboarding = "좋아요!\n어떤 고민이 있으신가요?"
    static let thirdOnboarding = "하루 중 어느 순간을\n가장 개선하고 싶으세요?"
    static let fourthOnboarding = "먼저,\n하지 않을 일을 정해요"
    static let fifthOnboarding = "낫투두를 실천할 방법과\n환경을 정해요"
    
    static let onboardingEmpty = ""
    static let subThirdbOnboarding = "여러 개 선택할 수 있어요"
    static let subFifthOnboarding = "달성률을 높이기 위해선 필수!"
    
    static let firstButton = "시작할래요!"
    static let thirdButton = "사용법이 궁금해요"
    static let fourthButton = "그리고요?"
    static let fifthButton = "로그인하고 시작하기"
    
    static let dailyPageControl = "나의 일상"
    static let usePageControl = "사용 방법"
    static let actionOnboarding = "실천 방법"

    /// Modal
    static let quitModalTitle = """
                              정말 낫투두와의 도전을
                              그만두시겠어요?
                              """
    static let quitModalSubtitle = """
                                 계정을 삭제하면 그 동안의
                                 기록이 모두 사라져요.
                                 """
    static let withdrawModalTitle = """
                                  다시 돌아오셨을 때
                                  더 나은 모습으로 도전을 도울게요.
                                  """
    static let withdrawModalSubtitle = """
                                     더 나은 서비스가 될 수 있도록
                                     무엇이 불편하셨는지 알려주시겠어요?
                                     """
    static let surveyButton = "이런 점이 아쉬웠어요.."
    static let cancel = "취소"
    static let delete = "삭제하기"
    static let deleteModalTitle = "삭제하시겠습니까?"
    static let deleteModalSubtitle = "한 번 삭제하면 되돌릴 수 없어요."
    static let update = "업데이트"
    static let updateAlert = """
                            최신 업데이트가 있습니다.
                            업데이트하시겠습니까?
                            """
    static let later = "나중에"

    /// home
    static let subText = "*달성 가능한 계획을 위해 다가올 일주일만 선택할 수 있어요"
}
