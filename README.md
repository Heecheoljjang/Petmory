# Petmory

애완동물과의 소중한 하루를 평생 간직하세요.

설명



## 공수산정


#### 9/8 ~ 9/11

- realm 모델 설계 [x]
- repository 패턴 적용 [x]
- 탭바 커스텀 아이콘 적용 [x]
- 메인화면
  - UI [x]
  - 검색화면, 모아보기 화면 띄우기 [x]
    - 모아보기 뷰컨트롤러에 서치 컨트롤러 추가 [x]
    - 우측 상단에 필터버튼
  - 작성 버튼(플로팅 버튼) [x]
  - 바버튼
    - 모아보기 화면 [x]
      - 애완동물 리스트 필터
    - 검색 화면 [x]
- 폰트 추가 [x]

#### 9/12 ~ 9/14

- 작성 화면
  - UI
  - 제목, 내용, 사진 기록
    - 제목으 디폴트값은 날짜, 사진의 디폴트 값도 따로 적용
  - PHPickerViewController로 사진 선택
  - 함께 보낸 반려동물 리스트 추가하는 컬렉션뷰
  - Alert
    - 취소, 필수 작성 내용
- 디테일 화면
  - UI
  - 삭제 기능
  - 스크롤뷰 적용
  - 함께한 동물 리스트 보여주고 눌렀을 때, 관련된 기록 모아보기 화면 띄우기
  - 사진 누르면 크게 띄우기
  - 공유 기능(확정x)

#### 9/15 ~ 9/18

- 일정 화면
  - UI
  - FSCalendar 적용. 일주일 달력 띄우고 한달 달력 보는 버튼 추가
  - 날짜를 선택하면 쓴 기록과 일정을 섹션 두 개로 나눠 보여줌
  - 이벤트 없는 날엔 문구 표시
  - 작성 때 선택한 색도 같이 표시
  - 탭했을 때 디테일 전체 내용 보여줌, 삭제 기능
- 일정 추가 화면
  - UI
  - 입력한 내용이 없다며 추가 버튼 비활성화
  - 날짜의 inputView는 datePicker인데 날짜, 시, 분, 오전/오후 한 번에 표시
  - 색 고르는 기능
  - 메모 placeholder

#### 9/19 ~ 9/21

- 펫 리스트 화면
  - UI
  - 테이블뷰로 사진, 이름 표시
  - 탭하면 디테일 화면 띄우기
  - 스와이프 액션(삭제)
  - 하단에 추가 버튼, 우측 상단에 설정 버튼
- 펫 정보(디테일) 화면
  - UI
  - 사진, 이름, 생일, 성별
    - 사진 누르면 크게 띄우기
  - 특이사항 표시
  - 하단에 관련 기록 보러가기 버튼
  - 없는 경우엔 누르면 alert띄우면서 작성하기 화면으로
  - 우측 상단 수정 버튼
    - 펫 등록 화면에 데이터를 채워서 띄우기
- 펫 등록 화면
  - UI
  - 이름, 성별, 생일, 사진, 특이사항 입력
  - 이름만 필수 항목으로
    - 필수 항목 입력 안하면 완료 버튼 비활성화(이름 옆에 필수표시)

#### 9/22 ~ 9/25

- 설정 화면
  - 백업/복구
    - 복구한 경우, 앱을 다시 시작해달라고 메세지 띄우기
    - 백업하기전ㅇ 앱을 지우면 파일 사라지니 파일앱에 저장하라고 메세지 띄우고 액티비티 컨트롤러
   - 문의/의견
    - 메일 보내는 화면 띄우기
   - 리뷰
    - 앱스토어로 이동시키기
- 온보딩
  - 페이지 컨트롤러로 일상 기록, 일정 추가, 펫 추가 방법
- 생일, 일정 알림
- 다국어 지원(영어)

#### 9/26 ~ 9/28

- 못한 것들 마무리

출시

#### 9/29 ~ 10/2

미정

#### 10/3 ~ 10/5

미정

## 
## 진행

### 9/8

#### 내용

- realm 모델 설계
- 폰트 적용
- repository pattern 구현 중

#### 이슈

- 스키마 정하는게 조금 헷갈렸음
- 레포지토리 패턴 적용하는데 어떻게 작성해야할지 모르겠는 메서드들이 좀 있어서 고민을 더 해야할듯.


### 9/9

#### 내용

- 메인화면 UI
- 모아보기 화면 UI
- 기본 세팅

#### 이슈

- UI를 수정하기로함.
  - 메인화면에서 다이어리를 탭하면 사진, 제목, 내용으로 이루어지 테이블뷰 리스트 띄우기
  - 오른쪽 바버튼에 검색 버튼, 필터버튼
    - 검색 버튼 누르면 검색화면 push
  - 필터 버튼 대신 네비게이션바 아래 컬렉션뷰 추가
    - 셀에는 등록된 펫 리스트 전부
    - 처음에는 전부 선택되어있지만, 탭하면 색 바뀌면서 필터에서 해제

- 디자인 생각하느라 진행이 많이 안된듯...
  - 색은 나중에 생각하고, 기본적인 레이아웃부터 신경써야할듯

#### 기억할 것

- 컬렉션뷰 dynamic width
  ~~~
  let cellSize = CGSize(width: "두부두부".size(withAttributes: nil).width + 20, height: 52)
  ~~~
  
- UIColor 헥사코드
  ~~~
  extension UIColor {
    static let diaryColor = UIColor(red: 0x40/0xFF, green: 0x53/0xFF, blue: 0x36/0xFF, alpha: 1)
    static let stringColor = UIColor(red: 0xEC/0xFF, green: 0xD8/0xFF, blue: 0xCF/0xFF, alpha: 1)
  }
  ~~~
  
#### 내일 할 것

- 다이어리 탭했을때 리스트 띄우기
- 메인화면 UI, 기능 완성
- 모아보기 화면 UI, 기능 완성
- 검색하기 뷰 띄우기
- 작성화면에서 데이터 저장하는 것을 우선으로 해야할지도
- 일정화면 UI 생각하기



### 9/10

#### 내용

- 메인화면 기능
    - 오늘 작성한 기록 리스트
- 탭바 아이콘 적용
- 작성화면에서 추가버튼 누르면 더미 데이터 생성
- 펫 등록 화면에서 더미 데이터 생성 기능
- 펫 리스트와 메모리 리스트에 따라 테이블뷰, 컬렉션뷰에 표시
- 검색 화면 구현
    - 실시간 검색 구현
- 모아보기 화면 펫리스트 컬렉션뷰 select, deselect효과 구현


#### 이슈

- realm의 list를 사용할때 옵셔널로 선언하면 인식이 안됐음.
- 메인 화면이나 모아보기 화면의 기능을 테스트하기 위해서는 더미데이터들이 필요함
    - 펫 생성, 작성하기에서 완료 누르면 데이터 생성하도록 함
- 필터링 구현을 어떻게 할지 고민을 너무 오래함.
- 내일 진행이 많이 되지않으면 계획이 틀어질 것 같음ㅠ

#### 기억할 것

- realm문서에 나와있는 형태와 조금이라도 다르면 지원안됨.
  
#### 내일 할 것

- 모아보기 테이블뷰 섹션 타이틀 날짜로
- 필터 기능 마무리
- 서치 컨트롤러쪽 배경에 검색결과가 없다는 문구 추가
- 더미 데이터 생성할때 고정데이터아니라 다르게
- DateFormatter 적용
- 디폴트 이미지 설정


### 9/11

#### 내용

- 작성하기, 펫 등록 다양한 더미 데이터 만들 수 있게 구현
- 모아보기 컬렉션뷰 UI 수정
- DateFormatter 구현
- 서치 컨트롤러 제거 후 서치바 적용
    - 실시간 검색 기능 재구현
- 모아보기 펫 필터 기능 구현(필터링 되는지만 확인)
- 작성하기 화면 UI 결정
    - 스크롤뷰 적용
    - IQKeyboardManager 적용
- 메인화면 UI 수정

#### 이슈

- 펫 필터가 제대로 적용되는지 보기 위해서 대충이라도 작성 화면이 필요했음.
    - 펫 등록도 대충이라도 만들어야함.
    - 공수산정 내용이 바뀔 것 같음. 제대로 안짰던 것 같음.
- 커스텀하게 alert뷰 만들기(나중에)
    - 펫 등록이 안됐을때는 화면 안보여주게하기
- 펫 사진 등록할떄 이미지피커 crop기능 쓰기
- 모아보기 필터 컬렉션뷰의 셀사이즈가 원하는대로 안나왔음.
    - 사이즈를 여유롭게 설정해서 해결
- 모아보기에서 섹션으로 구분하지않고 셀 안에 날짜를 표시하기로함
- 서치 컨트롤러를 빼고 서치바를 이용하기로 함.
- 작성화면 기본적인 것 구현한 뒤, 메인 화면 마무리해야할듯
- 이미지 여러장 어떻게 넣을지 생각해봐야함.(저장)
    - 툴바로 왼쪽에 이미지 오른쪽에 done버튼 넣어서 사진 추가되면 맨 첫 사진을 툴바 이미지뷰의 이미지로 설정

#### 기억할 것

- 코드로 스크롤뷰를 적용할 때, 스크롤뷰 > 컨텐트뷰 > 다른 객체들로 하고 height를 확실하게 정해야함.
    - 텍스트뷰의 스크롤을 막아야 height가 늘어남.
  
#### 내일 할 것(중요)

- 작성화면
    - 펫 선택 컬렉션뷰 구현
    - 이미지 컬렉션뷰 구현
        - ImagePicker 사용
        - 컬렉션뷰에서 이미지 삭제 버튼 구현
- 모아보기 UI 수정

### 9/12

#### 내용

- 작성화면
    - 펫 리스트 컬렉션뷰 UI 구현
    - 이미지 컬렉션뷰 UI 구현
    - PHPickerViewController적용(아직 사진 사용은 안함)
    - 메모리에 선택한 펫 리스트 추가해서 모아보기 화면에서 필터링 구현
    
    

#### 이슈

- textView의 enableScroll을 false로 하면 길이는 자동으로 늘어나지만 IQKeyboardManager의 자동 스크롤이 적용되지않았음.
    - 계속 고민하다가 해결 못 할 것 같아 내일 다시 하기로하고 다른 것으로 넘어가기로함.
- 똑같은 이름의 반려동물은 등록하지않는다는 것을 전제로 깔고가기로함
    - 등록은 가능하지만 같은 이름의 반려동물은 펫 리스트 컬렉션뷰에서 어차피 구분할 수 없음.
        - 필터링을 이름을 기반으로하기때문에 구별이 안됨.
- 텍스트뷰 placeholder 색이 조금 안맞는듯

#### 기억할 것

- shouldSelectItemAt은 didSelectItemAt이 실행되기전에 실행되는데, 반환값은 셀의 isSelected값을 반환하는거임. 즉, false를 반환하면 isSelected가 false가 되는 것.
- realm의 Results 리스트의 인덱스는 offset으로 접근. (enumerated)
  
#### 내일 할 것(중요)

- IQKeyboardManager 텍스트뷰 문제 해결
- 디테일 화면 구현
- 사진 가져와서 컬렉션뷰에 보여주기


### 9/13

#### 내용

- TOCropViewController를 이용해 이미지 편집 기능 추가
- 추가한 이미지를 작성화면에서 컬렉션뷰로 보여주기
- Data타입으로 이미지를 저장해서 컬렉션뷰에 보여줌
- 작성화면 스크롤뷰 없애고 텍스트뷰 스크롤 true
    - IQKeyboardManager사용

#### 이슈

- 사진을 한 번에 multiselection으로 선택하지않고 한장씩 추가할 수 있게함
    - edit하기 용이할듯
- 여러 장의 사진을 어떻게 저장해야될지
    - images폴더 안에 작성한 기록별로 폴더를 하나 더 만들어서 저장할예정
- 텍스트뷰의 스크롤이 꺼져있으면 iqkeyboard적용 안되는 것 같아서 다른 방법을 찾아봄
    - 그냥 작성화면에서는 스크롤뷰를 없애고 텍스트뷰에 스크롤을 넣기로함.
        - editing이 끝나면 텍스트뷰 스크롤 맨 위로
    - 디테일화면에서는 스크롤뷰를 통해 전체 내용을 보여주도록함.
- 텍스트뷰때문에 이틀을 날림..
    - 시간을 많이 날려서 다시 계획 짜야할듯
- IQKeyboard를 사용하면 검은색 화면이 살짝 보임
    - 스크롤뷰 포기못하겠어서 뒤의 것부터 얼추 만들어놔야겠음

#### 기억할 것

- 
  
#### 내일 할 것(작성하기 완성 안돼도 꼭 하기)

- 디테일 화면 구현
- 펫 등록 화면 UI 생각
- 일정 UI 생각

### 9/14

#### 내용

- 일정화면
    - UI 결정
    - FSCalendar적용
    - 일정 테이블뷰 뼈대 구현
- 일정 추가 화면
    - UI 결정해서 일부 구현

#### 이슈

- 작성화면 스크롤뷰 오류 해결하다간 다 망할 것 같아서 미룸
    - 진행중..
    - 결국 메모 눌렀을때 새로운 뷰 띄워서 해결할듯..
    - 텍스트뷰의 커서 위치를 이용해 해보려고했지만 실패
- realm 필터링할때 '' 빼먹지않기..
- IQKeyboardManager 처음에 검은색 화면뜸
    - 툴바의 영역이므로 다시 확인해보기

#### 기억할 것

- selectedRange와 caretRect를 이용하여 커서의 위치를 구할 수 있음.
    - 여유로울때 다시 확인해보기
  
#### 내일 할 것

- 일정, 일정 작성 화면 UI, 기능 구현
    - 추가, 수정, 삭제
- 시간되면 작성하기 화면 다시 시도해보기
    - 커서 위치로 해보다가 안되면 뷰 띄워서 해결하기

### 9/15

#### 내용

- 일정추가 화면
    - UI
        - 날짜 텍스트필드
            - inputView로 datePicker 사용
            - 커서의 색을 clear로 만들고, copy 등의 기능을 막아 편집이 안되게함
            - 현재 시간을 기준으로 기본적인 값이 들어가있음.
            - 현재 시간과 가장 가까운 시간을 계산하여 표시
                - Calendar의 component중 minute을 구하여 60에서 뺀만큼을 더해줘서 정각으로 표시하도록함
        - 컬러 태그
            - 스택뷰를 이용해 7개의 버튼을 추가함
            - 각 버튼을 누를때마다 프로퍼티에 색을 String형태로 저장하여 enum을 통해 일정 캘린더에서 알맞는 색으로 보여지게함
            - 각 버튼을 누를때마다 제목 텍스트필드 옆 뷰의 색이 바뀜
        - 메모 텍스트뷰
    - 완료 버튼을 누르면 제목, 날짜, 필터링을 위해 날짜의 간단한 문자열, 컬러, 메모, 등록시간이 저장됨.
    - modal형태로 띄워진 상태이므로, dismiss됐을때 테이블뷰를 리로드하기위해 NotificationCenter사용
        - 완료 버튼 누를떄 post

#### 이슈

- 일정추가 화면
    - 스택뷰를 이용할떄 자동으로 채워지도록 설정해놓고 아무생각없이 버튼마다 superView에 제약을 주었더니 오류가 생겼었음.
        - 스택뷰에 넣은 subView들의 제약을 설정할 필요없이, 스택뷰의 edgeInset, spacing등으로 처리가능
    - 위에 적었듯이 modal형태이기 때문에, NotificationCenter를 통해 테이블뷰를 리로드해줌
    - 날짜를 선택하고 추가 버튼을 눌러도 현재 시간으로 나옴. datePicker도 마찬가지
    - IQKeyboardManager를 사용하고 있기 때문에 툴바의 완료 메서드를 생각해야함. 지금은 날짜 선택이 되지않고 키보드 내리는 것만 됨.
- UI적인 고민이 많았음.
    - 날짜 텍스트필드 아래의 줄이 있는게 나은지 없는게 나은지

#### 기억할 것

- 사용자가 눈이 아플 수도 있으니 다크모드도 여유있으면 하는게 좋을듯
- 엑스코드 전체 파일을 검색할때 네비게이터 영역의 돋보기 모양에서 검색하면됨.
- dateFormatter에서 dateFormat의 시간이 HH인 경우엔 24시 형태로 표시, hh인 경우엔 12시 형태로 표시
- 스택뷰에서는 subView들의 레이아웃 제약을 굳이 줄 필요가 없음.
- modal한 형태로 띄워져, viewWillAppear등이 실행되지않을땐 NotificationCenter를 사용할 수 있음.

  
#### 내일 할 것

- 일정추가 화면
    - 메모 텍스트뷰 placeholder
    - 날짜 선택 후 일정 추가 버튼 눌렀을 때, datePicker와 날짜 textField의 text 나오게 구현
    - 수정, 삭제 기능 구현
- 작성 화면
    - 내용 텍스트뷰 눌렀을때 작성하는 뷰 띄워서 해결해보기
- 일정 화면(시간되면)
    - Memory 데이터를 가져와서 작성한 기록 보러가기 버튼 눌렀을때 테이블뷰로 보여주기
    - UI 수정
- 계획 다시 세우기

### 9/16

#### 내용

- 일정추가 화면
    - 메모 텍스트뷰 placeholder
    - 선택한 날짜 적용
    - datePicker도 날짜 TextField에 있는 날짜로 초기값 설정
- 일정 화면
    - 테이블뷰 헤더 타이틀 설정(UI는 아직)
    - 선택한 날짜의 일정이 없는 경우엔 일정 없다고 표시
    - 삭제 기능 구현(UX적인 부분빼고 기능만)
    - 테이블뷰에서 들어왔을때와 새로 작성인 경우를 구분(BarButton)
    - 수정 기능 구현
        - 일정추가 화면과 같은 뷰컨트롤러를 사용
        - CurrentStatus 열거형을 이용해 현재 상태가 새로 작성하는 상태인지, 편집인지 구붐
- 작성 화면
    - 내용 텍스트뷰 눌렀을 때 작성하는 뷰 띄워서 값 전달을 통해 구현
    - 클로저를 이용해 present된 작성 뷰에서 작성된 텍스트를 작성 화면의 textView의 text로 설정
    - 작성한 내용이 없는 경우엔 placeholder 보여줌
    - 작성하는 뷰를 띄웠을 때 becomeFirstResponder를 이용해 작성화면 띄움
    - 작성된 텍스트가 있는 경우엔 작성하는 뷰를 띄웠을때 작성된 텍스트도 같이 전달
    

#### 이슈

- 일정 화면
    - 분명 프로퍼티에 접근해서 데이터를 전달했는데 캘린더에서 선택한 날짜가 전달안되는 이슈가 있었음
        - transition메서드에서 만든 인스턴스 프로퍼티를 사용한게 아니라 다시 FooViewController()형태로 줬기 때문이었음
        - vc라는 프로퍼티를 만들어서 vc.date에 데이터를 전달했는데 vc가 아니라 FooViewController()를 띄운다면 전달될 리가 없었음
    - Notification을 사용해서 테이블뷰를 리로드할때 서로 다른 메서드에서 같은 이름의 Notification을 post하니 동작 제대로 안함
        - 하나의 옵저버는 하나의 post만 받을 수 있음
        - 삭제, 완료 두 개의 버튼에서 사용되므로 옵저버도 두 개 생성
            - Notification의 메서드는 같은 메서드를 사용해도됨
    - 일정을 추가하면 테이블뷰가 리로드 안되는 이슈가 있었음.
        - Notification의 메서드 내에 다시 task를 가져오도록해서 didSet 실행
- 작성 화면
    - 이미지 컬렉션뷰에서 이미지 페이징이 약간 부자연스러움

#### 기억할 것

- 루트뷰컨트롤러가 아닌 경우엔 옵저버가 쌓여서 동작이 이상하게 될 수도 있으므로 remove 반드시 해줘야함.
- 데이터 전달에는 여러 방식이 있지만, 쓰임이 다 다르기때문에 통일시킬 이유가 전혀 없음.

#### 내일 할 것

- 작성 화면
    - 이미지 컬렉션뷰 이미지 페이징 이슈 해결
    - 수정, 삭제 구현
    - 데이터 테이블뷰에 보여주기
- 펫 등록 화면
    - UI 생각해보기
    - 만약 UI 결정하면 데이터 추가 기능 구현
