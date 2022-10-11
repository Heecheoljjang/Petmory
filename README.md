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

### 9/17

#### 내용

- 탭바
    - top과 bottom에 inset을 줘서 아래로 내림
- 메인 화면
    - 등록한 펫이 없으면 작성화면 띄우지않게 함(alert는 아직)
- 작성 화면
    - 이미지 컬렉션뷰에서 다음 사진으로 넘어갈때 superView보다 커지므로 clipsToBounds로 해결
    - 이미지 추가하면 뒤에 생기는 것을 맨 앞에 생기도록함
    - 작성 기능 오류 수정
    - 추가한 사진 삭제 기능 구현(나중에 당근마켓 형식으로 UI 수정하는 것도 괜찮을듯)
        - 셀마다 버튼을 등록해서 tag를 이용해 imageList의 원소를 제거하고 reload
- TodayList 화면
    - 탭하면 데이터 전달해서 디테일화면 띄우기(일단 UI는 대충)
- 디테일 화면
    - 데이터 받아와서 뷰에 표시
    - 삭제 기능 구현
    

#### 이슈

- 작성 화면
    - 펫 리스트만 선택하고 제목을 비워둔 상태로 완료버튼을 누른 뒤, 펫 리스트를 선택하지 않고 눌러보면 선택된게 있다고뜸
        - 완료 버튼 맨 첫 줄에 선택한 펫 리스트를 비우는 코드를 작성하여 해결
    - 컬렉션뷰 scrollIndicator 제거
    - 셀 내의 버튼 addTarget을 뷰 클래스에서 만들어보려고 했으나 실패
        - 뷰컨트롤러에서 해결하고 prepareForReuse에서 remove함

#### 기억할 것

- 추가한 사진을 삭제하는 버튼의 addTarget을 할 때 MVC패턴에서는 뷰컨트롤러에 하기

#### 내일 할 것

- 작성 화면
    - 편집 기능 구현
    - 펫 리스트 선택하는 것을 다 보여주고 선택하는게 아니라 하나씩 추가하게 만들어서 List로 보관해야 편집하기 편할 것 같음
- 펫 등록 화면

### 9/18

#### 오늘 할 것

- 작성 화면
    - 편집 기능
    - 네비게이션아이템의 titleView 적용(폰트, 탭 제스처)
        - 탭하면 날짜 선택할 수 있게. 디폴트값은 오늘 날짜
        - UserMemory 컬럼 수정 필요
            - 기존에 Date()값을 바로 넣었지만 선택한 날짜를 받을 수 있도록
- 디테일 화면
    - 사진 없을 때 안보여지도록 UI 수정

#### 내용

- Realm
    - UserMemory 컬럼 추가
- Repository
    - 기존의 fetchMemory를 fetchToday와 fetchAll로 나눠줌
- 작성 화면
    - titleView 추가
        - 탭해서 날짜 수정 가능
        - 수정한 날짜를 기준으로 데이터 가져오게 구현
        - inputView를 datePicker로
        - 툴바 추가
    - 편집 기능 구현
- 모아보기 화면
    - 셀 탭하면 디테일 화면 띄우기
- 펫 등록 화면
    - UI

#### 이슈

- 작성 화면
    - 편집 상태로 들어갔을때, 사진을 삭제하면 오류가 뜸
        - 편집 상태로 갈 때 현재의 task를 UserMemory타입인 프로퍼티에 데이터를 넣어서 imageList를 설정했는데, 이러니까 수정이안됐음.
        렘에서 받아온 데이터를 넘겨준 거라 같은 타입이어도 직접 접근해서 수정은 못하는 것 같았음. 그래서 imageList = currentTask.imageList형태가 아닌 forEach문을 이용해 currentTask의 imageList 원소를 하나씩 직접 imageList에 넣어서 해결함.
    - titleView에 Label을 넣어서 탭 제스처로 띄우려고 했는데 그냥 textField를 넣고 inputView를 사용하기로함
    - 날짜 선택할 수 있는 기능이 추가되니 기존에 메인 화면에서 오늘 날짜 데이터를 패치해오는 메서드를 수정해야했음.
        - TodayList, 모아보기 화면 fetch메서드 수정
    - 디테일화면에서 편집을 누르면 present되면서 띄워지므로 수정한 뒤 그냥 dismiss하면 보여지고있던 디테일 화면은 바뀌지 않음
        - objectId를 이용해서 viewWillAppear에서 task를 다시 fetch해줌.
    - 툴바를 달고 레이아웃 이슈가 생김
        - 실제로 볼 때는 큰 문제는 없기도 하고, 그냥 넘어가도 될 것 같아서 그대로 진행
- 디테일 화면
    - 사진이 없는 경우에 이미지뷰를 없애고 싶었는데 잘 안됨
- 펫 등록 화면
    - 분명 똑같이 제약을 줬는데 nameLabel의 width가 늘어났음
        - 우선순위 이슈같은데 왜 같은 상황에서 다르게 적용되는지 모르겠음.
        - width값을 줘서 해결함
        

#### 기억할 것

- 

#### 내일 할 것

- 펫 등록 화면
    - 사진 추가 및 데이터 저장 기능 구현
- 펫 리스트 화면
    - 테이블뷰를 이용해 펫 리스트 보여주기
- 디테일 화면
    - 이미지뷰 처리


### 9/19

#### 내용

- Realm
    - 모델, Repository 메서드 수정
- 펫 등록 화면
    - 펫 데이터 저장
    - 이름, 성별, 사진 필수
    - 사진 crop은 원모양으로
- 펫 리스트 화면
    - 테이블뷰로 펫 리스트 표시
    - 셀 탭하면 편집 화면 띄우기
    - 펫이 없으면 문구 띄우기

#### 이슈

- 기획 수정
    - 펫 디테일 화면을 없애고 펫 리스트에서 펫을 누르면 수정 화면이 뜨게끔 구현하기로 결정
        - 모아보기에서 펫 별로 필터링이 가능한데 굳이 펫 별로 모아보기가 필요할까 싶었음.
    - 리스트 화면에서 가장 위나 아래 셀을 추가 셀로 만들고 오른쪽 바버튼을 설정으로 할까 생각중 -> 이상할지 확인해보기
    - 리스트 화면에서 이름 아래에 삭제 버튼을 따로 만들기로함
        - 수정 화면은 등록 화면과 동일하게
- 탭바가 있는 상태에서 평소처럼 그냥 title = "foo"로 설정하면 탭바의 타이틀까지 바뀜


#### 기억할 것

- 탭바가 있을때 네비게이션 컨트롤러의 타이틀만 설정하고 싶을때
    ~~~
    navigationItem.titl = "foo"
    ~~~

#### 내일 할 것

- 펫 리스트 화면
    - 삭제하기 버튼 추가
    - 마지막 셀을 셀 추가 버튼으로 구현해보기
- 펫 등록 화면
    - 편집 기능
- 디테일 화면
    - 이미지뷰 처리


### 9/20

#### 내용

- 펫 등록 화면
    - UI 완성
        - 스크롤뷰 적용
        - 바버튼대신 하단에 등록 버튼 추가
    - 수정, 삭제 기능 구현
        - 편집 상태인지 확인해서 스택뷰로 삭제 버튼 표시 유무와 등록 버튼 타이틀 설정
- 작성 화면
    - 네비게이션 타이틀뷰 날짜 오류 수정
- 디테일 화면
    - 추가한 사진이 없는 경우, 이미지 컬렉션뷰를 hidden시키고 레이아웃 조정

#### 이슈

- 마지막 셀을 등록하기 셀로 설정하려 했는데 하나의 섹션 내에서는 두 개의 셀 클래스가 적용되지 않음.
    - identifier 이슈였음. 기존에
    ~~~
    static let identifier = String(describing: self)
    ~~~
    라고 작성해놨기때문에 셀.Type이 들어간게 아니라 의미없는 cell.self가 들어간것
- 셀내의 버튼에 addTarget으로 액션을 추가했는데 동작안함
    - 셀에 직접 addSubView하면 contentView뒤로 들어가기때문에 작동되지않기때문에 contentView.addSubview이용해야함
- 편집 화면에서 타이틀뷰의 날짜 텍스트가 오늘 날짜로 나옴.
    - 타이틀뷰의 텍스트만 바꿔주면 alignment가 오른쪽으로 치우치는 오류도 있었음
    - 타이틀뷰의 텍스트가 바뀔때마다 navigationItem.titleView 를 다시 설정해서 해결
- 편집으로 사진을 지웠다가 다시 추가했을때 스택뷰에 이미지가 로드되지않거나 기존의 이미지가 추가돼서 중복됨.
    - PHPicker에서 사진을 선택하면 imageList에 데이터가 추가됨..
    - CropViewController띄우기전에 PHPicker가 dismiss되면서 viewWillAppear의 코드가 실행되는 것이 이유였음
        - 내일 해결해보기..

#### 기억할 것

- 셀에 버튼을 addSubView할때는 contentView에 하기

#### 내일 할 것

- 작성 화면
    - 편집 시 이미지 컬렉션뷰 오류 해결
- 설정 화면
    - UI 구현(테이블뷰)
- 노티피케이션 알아보기



### 9/21

#### 내용

- 알림
    - 알림 권한 요청을 사용자가 왜 필요한지 알 수 있게 하기 위해 일정 추가했을 때와 반려동물을 등록했을 때 요청을 보내도록 구현
    - 반려동물의 생일은 year없이 month와 day만 일치하면 알림 띄우고, 일정은 year까지 전부 동일해야 알림띄움.
        - 그래서 일정의 알림은 repeat을 false로 함
    - foreground에서도 알림을 받기 위해 AppDelegate에서 UNUserNotificationCenterDelegate채택한 뒤, willPresent에서 구현
    - registerDate를 identifier로 설정하여서 수정한 경우에 기존의 notification을 지워주고, 새로 등록해주도록함.
- 디테일 화면
    - 메뉴버튼 적용
        - 수정, 삭제 기능
- 일정 화면
    - FSCalendar UI 일부 수정

#### 이슈

- 작성화면
    - 편집할때 사진이 중복돼서 추가되는 것은 imageList데이터 채우는 것을 화면전환이 되기 전에 실행되도록해서 해결했음
    - 사진이 세 장 있었다가 지우고 두 장만 하면 빈 셀이 자꾸 보임. not valid for the data source counts오류가 뜸..
- 알림 권한 요청을 할때 requestAuthorization(options, completionHandler) 메서드를 자동완성 시키면 옵션이 빠지고 자동완성됨
    - 옵션이 없는 경우엔 알림 권한 요청을 물어보지않음. 그래서 자동완성을 할 때 option과 엔터키를 같이 눌러 전체를 자동완성 시켜줘야함.
- 디테일 화면
    - 사진을 전부 지웠다가 다시 추가하면 리로드가 되지않음.
        - 리로드 시점 문제 같음. 지금은 편집 화면에서 수정된 데이터를 디테일 화면의 viewWillAppear에서 데이터를 받아와서 처리하는 상태임

#### 기억할 것

- 공식문서를 보면 알림 권한을 요청하는 것은 사용자에게 알림 권한이 왜 필요한지 알 수 있는 맥락에서 요청을 보내는 것이 좋다고함.
- Date타입은 옵셔널로 선언하고 초기화를 하지 않아도 현재 시간의 옵셔널값이 들어감


#### 내일 할 것

- 일정화면
    - 캘린더 UI 완성
- 작성 화면
    - 이미지 컬렉션뷰 안맞는거 해결
    
### 9/22

#### 내용

- 설정 화면
    - UI 
- 디테일 화면
    - viewDidAppear에서 리로드를 해서 임시로 이미지 컬렉션뷰 오류 해결

#### 이슈

- 디테일 화면
    - 이미지 컬렉션뷰 reload를 더 천천히하면 문제가 없었음
        - jpeg파일을 불러오는게 속도가 더 빠르다고 해서 적용해 보기로함. 문자열 리스트형태로 렘에 저장해서 파일 불러오는 형식으로
        - 도큐먼트 폴더에서 파일을 가져오는 것과 데이터 타입의 문제가 아니라 수정하고 pop될때 viewWillAppear에서 데이터를 다시 fetch하는데에 시간이 모자란 상태임.
        - 작성화면에서 사진을 지울 수도 있기때문에 완료 버튼을 눌렀을때 도큐먼트 폴더에 있는 해당 task의 이미지를 전부 지운 뒤, 다시 저장
        - 근데 이미지 url에 접근이 잘 안됐음
            - 도큐먼트 폴더에서 확인해보니 : 이 문자가 /로 바뀌어서 저장되어있었음. 따라서 기존에 저장되어있는 이름의 파일을 지우면 지워지지않는거였음.
            - : 랑 상관없이 FileManager메서드에서 appendingPathComponent대신 appendingPathExtension을 사용해서 안지워진거..
            - 계속 잡고있기에 시간이 모자라서 일단은 다시 데이터 타입으로 돌아가서 오류 해결해보기로함..
        - 데이터 타입으로 할 땐 용량이 큰 사진들은 리로드하는데 시간이 오래걸려서 마찬가지로 빈 화면이 보임
        - 용량이 큰 것보다 사진이 0개에서 늘어나게되면 문제가 생김
            - 보니까 데이터 용량은 전혀 문제 없었음. 사진이 있는 상태에서 용량이 큰 사진을 추가해도 문제없이 리로드가 잘됨.
            - 일단 viewdidAppear에서 리로드해서 사진이 리로드되는건 확인함. stackView의 히든과 관련있는듯. 히든이 풀린뒤에 리로드하는건의미가 없고
            viewDidAppear에서 하는 것만 적용됐음...
            - 내일 물어보고 좋은 방향을 찾아보기
- 작성 화면
    - PHPicker가 뜰때마다 viewWillAppear가 실행돼서 날짜를 바꿔줘도 사진을 고르고나면 다시 원래대로 돌아옴
        - edit상태인 경우에 memoryDate를 계속 currentTask.memoryDate로 설정해서 그런거였음
            - 화면 전환할때 memoryDate를 같이 전달하고 viewWillAppear에서의 코드를 지워서 해결


#### 기억할 것

- 


#### 내일 할 것

- 

### 9/23

#### 내용

- 일정 화면
    - leftBarButton으로 현재 날짜 표시(년, 월)
        - 스와이프로 month를 바꾸면 calendar.currenPage의 값으로 title을 수정
    - 버튼을 누르면 actionSheet을 띄우도록함

#### 이슈

- actionSheet에 datePicker를 넣으려고 했는데 view의 크기를 따로 지정하지않으니 늘어나지않아 datePicker가 밖으로 튀어나옴
- 머리가 안돌아가서 거의 못함
    - 오늘 푹자기

#### 기억할 것

- FSCalendar
    - calendarCurrentPageDidChange 메서드를 통해 스와이프 됐는지 알 수 있음. 이때 calendar.currentPage를 출력해보면 해당 월의 마지막 날짜가 나옴


#### 내일 할 것

- 


### 9/24

#### 내용

- 일정 화면
    - leftBarButton을 누르면 날짜 선택하는 actionSheet띄우기
    - 오늘 버튼 추가
    - 6주차까지 나오는 것 해결
        - placeholderType을 fillHeadTail로 설정
    - 테이블뷰와 캘린더 사이에 날짜 표시 레이블 추가
    - 일정 추가 버튼을 플로팅 버튼으로 변경
- 메인 화면
    - dateLabel 오류 수정
- 모아보기 화면
    - 날짜 별로 섹션 구분
        - memoryDate로 필터링해서 Set으로 중복 처리
- TodayList 화면
    - 삭제해서 task의 count가 0이됐을때 pop해주도록 함.
- 검색 화면
    - 셀을 탭하면 디테일 화면 띄우기
    

#### 이슈

- 일정 화면
    - actionsheet에 datepicker를 넣어주는데, 레이아웃 제약조건을 잡을때 actionsheet.view.addsubview(datePicker)가 레이아웃 잡는 코드보다 뒤에 오면 오류 발생
        - contentViewController를 만들어서 setValue로 해결
        - 이때, forKey는 contentViewController로 해야함.
- 메인 화면
    - 12시 전에 앱을 켜놓고 12시 이후에 작성하면 viewDidLoad에서 설정된 레이블이 그대로 남아있음
        - viewWillAppear에서 해결
- 모아보기 화면
    - 섹션의 마지막 셀을 지우면 index 런타임 오류 뜸.
        - task의 didSet에서 테이블뷰를 리로드하는 코드가 있었는데, 섹션을 나누는 dateList는 viewWillAppear에서 업데이트하기 때문
        - task didSet에서 dateList를 바로 업데이트해서 해결
- 작성 중에 취소하거나 일정, 일기를 삭제할 떄 alert 문구 고민해야할듯..
    
    


#### 기억할 것

- 



#### 내일 할 것

- 


### 9/25

#### 내용

- 취소, 삭제 시 alert로 확인하기
- 디테일 화면
    - weak self를 이용해 메모리 릭 해결
- 모아보기 화면
    - UI 수정
        - 테이블뷰 헤더
        - 이미지뷰 추가
        - 이미지 여러 장일때 표시
- 검색 화면
    - UI 수정

#### 이슈

- 디테일 화면
    - 사진을 삭제하고 수정하면 런타임에러뜸
        - 같은 환경에서 원래는 발생안했음.. 다시 해보니까 발생 안함.
    - 메모리 릭 발생함.
        - 디테일 화면만 deinit이 안됨.
        - 하나씩 주석처리해가면서 확인해보니 setUpController에서 참조가 발생하고 있었음.
        - 메뉴 버튼의 UIAction내의 클로저 떄문이었음. weak self를 이용해 해결
            - 버튼의 액션과는 뭐가 다른지 잘 모르겠음.. 출시 뒤에 더 공부해보기
    - 이미지를 탭하면 원본 비율로 볼 수 있는 뷰 띄움
        - pageControl 사용
        
- TodayList 화면
    - 모아보기 화면은 present고, todayList는 push이다보니 todayList를 통해 디테일 화면으로 들어갔을때 탭바가 보임
        - 똑같이 present로 띄우기로함.
            - 이렇게 해결하니 백버튼의 역할이 달라 문제가 생김.
            - 그래서 TodayList화면을 present로 띄움
- 일정 화면
    - 12시전에 앱을 실행하고 다시 일정 화면을 들어가도 오늘 날짜가 그대로였음
        - viewWillAppear에서 reload시켜줌
- 모아보기 화면
    - 반려동물이 등록되어있지 않으면 들어갈 수 없지만 반려동물을 다 지우면 기존의 기록들은 남아있음
        - 냅두는 방향으로 갈듯



### 9/26

#### 내용

- 백업 복구 구현중

#### 이슈

- 디코딩하는 메서드를 제네릭을 이용하려고 했는데, 제대로 적용되지않아서 따로따로 구현함
    - 제네릭을 이용하게되면 들어온 값으로 추론을 하게 되는데, 디코딩을 하기 위해서는 codable 구조체나 클래스가 필요함. 즉, 제네릭만 사용해서는 어떠한 구조로 받아올지 알 수 없기때문에 사용할 수 없는 것 같음.
- Memory만 json파일이 안만들어짐..
    - 근데 용량은 있음. 뭐지

#### 기억할 것

- self._가 무슨뜻인지 알아보기
- CodingKeys를 설정할때, String이 CodingKey보다 먼저 채택되어야함.
    - 얘도 이유 알아보기. 지금 시간없음


### 9/27

#### 내용

- 설정 화면
    - UI 수정
    - 백업 복구 구현
        - 개별 화면 추가
        - realm에 codable을 채택하여 json파일로 변환한 뒤 압축해서 저장하고, 복구할땐 디코딩하여 각 모델의 배열들을 localRealm에 write하였음.
        - hud 추가
        - Petmory의 백업 파일이 아닌 경우엔 Alert띄움.
    - 문의하기
        - 셀을 누르면 메일 보내는 창 띄움
            - MFMailComposeViewControllerDelegate 사용
- 타이틀뷰 폰트 적용
- 백업 복구 화면
    - UI 구현
        - 테이블뷰 헤더를 사용하지 않고 따로 레이블을 두어 스크롤되지 않게 구현
            - leastNormalMagnitude 사용
    - 백업 파일 보여주는 테이블뷰 추가

#### 이슈

- 메일 보내거나 취소를 눌러도 창이 내려가지 않음.
    - 그냥 delegate가 아니라 mailComposeDelegate의 대리자를 설정해야함..
- 테이블뷰의 스타일이 insetGrouped인 경우엔 상단의 기본적인 spacing이 있음.
    - 가장 작은 양의 수를 반환하는 leastNormalMagnitude를 이용하여 헤더의 height를 설정해서 해결

#### 기억할 것

- 


### 9/28

#### 내용

- 메인 화면
    - 컬렉션뷰 적용
        - 날짜를 기준으로 필터링해서 페이지 수 표현
        - 탭하면 해당 날짜에 쓴 기록 테이블뷰로 표시
        - scrollToItem을 이용해서 처음 앱을 켰을때에만 오늘 날짜로 스크롤시킴
            - viewDidLayoutSubviews에서 실행
            - centeredHorizontally로 포지션을 설정
    - 타이틀 뷰에 년도 띄우기
        - PickerView로 선택하게 구현
- 한 달 화면
    - 작성 기록이 없는 경우엔 레이블을 띄움.
- 모아보기 화면
    - 섹션을 한달로 나눔
- 일정 화면
    - 오늘 버튼 눌렀을때 데이터 안보이는 오류 해결
    - 등록하는 일정이 현재 시간보다 과거인 경우, 노티를 보내지않음
    - 일정 삭제 시 노티도 제거
- 펫 등록 화면
    - UI UX 수정
        - alert
        
- 크롭뷰컨트롤러 버튼 색 수정
        

#### 이슈

- 피드백
    - 메인 화면에 컬렉션뷰를 추가해서 월별로 볼 수 있으면 좋을 것 같다고하셔서 우선적으로 구현해볼 예정
        - dateString값으로 년, 월이 같은 것을 따로 필터링하면될듯
- 메인 화면
    - 상위뷰에 shadow특성을 넣으면 하위 뷰에도 적용이됨
    - 처음에만 가장 마지막 셀로 스크롤해주고싶음
        - viewDidLayoutSubviews를 이용했지만 뷰를 나갈때마다 움직이는게 보이고 너무 자주 호출됨.
            - 그래서 더 물어보고 결정해야할듯
    - 멘토님께서 데이터가 있는 날짜보단 일년 전체를 보여주는게 나을 것 같다고 하셔서 수정
        - 타이틀뷰에 년도를 넣기로
            - 피커뷰를 만들어서 년도를 선택할 수 있게함.
- 한달 화면
    - 모아보기 화면에서만 검색과 필터 기능을 넣고 여기서는 빼기로함
- 일정 화면
    - 제목을 입력하지 않았을때 뜨는 alert이 바로 사라짐
        - transition코드 위치를 변경해서 해결

#### 기억할 것



### 9/29

#### 내용

- 일정 화면
    - 캘린더의 max min date설정
- 모아보기 화면
    - 셀 UI 수정
        - 이미지뷰를 스택뷰에 넣어 이미지가 없는 경우엔 제목과 내용이 더 길어지게함
        - 날짜 추가
        - 이미지뷰 width 조정
- 작성 화면
    - UI 수정
- 디테일 화면
    - UI 수정
- 데이터 복구 화면
    - 복구 시 rootViewController로 돌아가게함
        - 애니메이션 추가
- Picker
    - 완료 버튼을 눌렀을때 값이 바뀌도록
- 앱 아이콘 생성

#### 이슈

- Picker
    - 2099년 이후 날짜를 선택하면 오류
        - datePicker의 maximumDate를 직접 설정해서 해결
- 작성화면에서 이미지 컬렉션뷰의 이미지 삭제 버튼이 탭이 잘 안됨.
    - 셀 밖에 버튼이 위치해있어서 그런거였음.
    - 셀의 width를 키우고 삭제 버튼을 조금 더 안쪽으로 가져와서 해결
- 디테일 화면
    - 사진 여러장인 것을 표시하는 이미지가 뜨지 않음.
        - 계층구조때문이어서 상단으로 올려줌.
- 모아보기 화면
    - 이미지가 없어도 스택뷰가 히든되지않는 오류가 있었음.
        - 이미지뷰의 제약을 width만 줘서 해결
- 검색 화면
    - 스크롤 할 때와 검색 버튼 눌렀을 때 키보드 내려줌
#### 기억할 것



### 9/30

#### 내용

- 오류 수정
    - 이미지뷰 contentMode 변경
    - 일정 수정 시 변화없이 완료 누르면 안내려가는 오류 해결

#### 기억할 것

- 출시되면 업데이트로 버그 해결하기



#출시 이후

### 10/1

#### 내용

- 피드백 반영
    - 반려동물이 한 마리인 경우엔 작성화면에서 선택되어 있으면 좋겠다
        - petList의 count가 1인 경우엔 selectItem를 이용해 해당 셀을 선택 상태로 만들어줌.

#### 이슈

- 복구하면 알림이 오지 않음
    - 복구를 진행할 때 다시 알림을 등록해줬는데도 오지않음. 내일 다시 해결해보기


### 10/2

#### 내용

- 오류
    - 복구했을때 알림이 오지않는 버그 수정
        - 복구한 뒤, 일정과 반려동물 리스트의 정보로 sendNotification메서드 실행
- UI 수정
    - 메인 화면과 작성 화면에서 타이틀뷰를 선택하면 날짜를 변경할 수 있는데, 사용자 입장에서 잘 모를 것 같음
        - 아래 화살표 이미지를 넣어줘서 더 알아보기 쉽게 해줌
        - 기존에 텍스트필드와 inputView인 datePicker였지만, 버튼 하나와 PickerView, ActionSheet을 이용하는걸로 변경. 작성 화면에서는 기존과 같이 datePicker사용
    - actionSheet으로 데이트피커를 띄울 때, 취소 버튼 추가

#### 이슈

- datePicker에서 취소버튼을 누르는 경우, 마지막 포지션이 남아있음.
    - 취소 버튼을 눌렀을 때 현재의 값으로 바꿔주면 될 듯

### 10/3

#### 내용

- UI 수정
    - 테이블뷰 separator 추가
    - 디테일 화면 내용 텍스트뷰 레이아웃 수정
    - 작성 완료 alert 추가
    - toolBar tintColor 수정
    - toolBar done버튼 이름을 완료로 수정
    - 반려동물 리스트 화면 이미지뷰 크기 줄임
- 오류
    - 디테일 화면 타이틀 길면 잘리는 오류 수정

#### 이슈

- MonthMemoryViewController에서는 첫 셀 위에 separator가 거슬렸음
    - tableHeaderView = UIView() 로 해결

### 10/4

#### 내용

- 설정 화면
    - 하단에 버전 정보 추가
- UI 수정
    - 모아보기 화면
        - 테이블뷰 separator 색 조금 더 진하게 변경
        - 테이블뷰 셀 글씨 크기 수정
- 백업 복구
    - 내 앱의 백업 파일인지 확인하는 로직 추가
    - 백업 파일 잘못된건 바로 삭제
- 오류
    - 알림 권한 요청 메서드에서 alert 띄우는거 제거


### 10/5

#### 내용

- 레이블에 g, y, p같은 알파벳이 들어가면 잘리는 오류 수정
    - drawText를 이용해 padding을 주는 Label클래스를 만들어서 해결
    - 이때 line 사이의 간격이 좁다보니 글자들이 겹치는 오류가 생김
        - NSMutableAttributedString을 이용해 lineSpacing을 줌.
- 반려동물 등록
    - 반려동물의 이름을 바꾸면 필터링이 제대로 되지 않는 오류 수정
        - 현재 string형태로 petList를 갖고 있으므로 반려동물의 이름이 중복되지 않도록 수정
        - 이름이 수정되는 경우, 메모리의 petList도 수정하도록해서 필터링이 문제없도록 함.

### 10/6

#### 내용

- FireBase를 이용하여 앱의 애널리틱스와 크래시리틱스 적용
    - 첫 화면, 작성버튼 눌렀을때, 일정 등록버튼 눌렀을때, 반려동물 추가버튼 눌렀을때, 잘못된 백업파일을 넣는 경우, 그리고 복구에 성공했을때에 이벤트를 등록함.
    - 이벤트의 이름을 작성할때 한글 안되고, 띄어쓰기 안됨.......
    - fulltext는 없어도 됨.
- 접근 제어자 추가

#### 이슈

- 일정 화면
    - 데이트 피커를 이용해 날짜를 바꾸고 오늘 버튼을 누른 뒤, 데이트피커를 바로 선택 완료하면 이전에 선택된 날로 감.
        - 오늘 버튼 눌렀을 때 코드를 추가하여 해결

### 10/7

#### 내용

- default.realm이 압축되어있는 백업 파일인 경우 복구가 안되게 함.
- 다른 앱의 백업 파일로 복구했을때 데이터가 남지않도록 삭제

#### 이슈

- 복구 시, json형태가 아닌 default.realm파일 자체를 압축시킨 파일의 경우 압축을 풀면 내 realm과 대치되어 런타임 오류 발생
- 일정 화면에서 일정 제목이 길어지면 확인할 수 없는 오류가 있음
    - 뷰를 하나 더 추가할 예정(애플캘린터처럼)

### 10/8

#### 내용

- 일정 제목 길어지면 확인할 수 없는 오류 해결
    - 텍스트필드를 텍스트뷰로 바꿈
    - 글자 수를 제한(150자)
    - 아예 텍스트가 없는 경우에는 alert을 띄우고, 공백만 있는 경우엔 새로운 일정이라고 보이게함.
- 이미지 이름 하드코딩 enum으로 정리
- 1.2.0 업데이트


### 10/9

#### 내용

- 문자열 하드 코딩 enum으로 정리
    - 나중에 다국어대응을 하게되는 경우, 더 편할 수도 있음
- 백업 복구 코드 가독성 개선
    - 기존의 이름으로 백업 파일 판단하는 로직 제거
    - hud 위치 수정
    - 전체 삭제, 전체 추가 같은 메서드를 repository에 따로 만듦
- 반복되는 코드, 안쓰이는 코드 제거


### 10/11

#### 내용

- Remote Notification 적용

