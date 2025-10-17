# PWM_LED
使用兩個計數器交替運作來模擬PWM的訊號，控制LED燈的亮滅。

運用上次作業的兩個計數器來模擬PWM訊號，採用8位元的寬度，一個上數一個下數，兩者的計數值相加為255(2^8 = 255)。
  
這次的作業再做一個FSM2來控制變亮與變暗狀態的轉換，reset後讓LED漸漸變亮，若已經最亮了就跳到漸漸變暗的狀態去。
  
upbnd1與upbnd2則是兩個計數器的計數上限，用來控制LED的亮暗程度，兩者為互補關係，相加是255，檢測是否已經最亮或最暗只要看其中一個就好。  
(第一個Bug，gettingBright與gettingDark裡面統一去檢測upbnd1或upbnd2即可)。

upbnd1p與upbnd2p是控制兩個計數器的上下限值，一個上數一個下數，同步運作，alreadyP_PWM_cycles會傳入這兩個process來改變上下限值，這樣就實現了PWM的功能。  
upbnd1p只管upbnd1，upbnd2p只管upbnd2(第二個bug，upbnd2p裡面打錯，出現upbnd1)。

程式裡面宣告了一個"P"值，用來設定PWM是否過了P個cycle，這麼做是為了避免PWM切換亮暗的速度太快，以免看不出來波形的變化。  
先使用一個detect_PWM_pos_edge來抓取PWM的正緣訊號，然後傳入P_PWM_cycles去計數是否過了指定的P個cycle，如果過了就讓alreadyP_PWM_cycles輸出為1。
(第三個Bug，P_PWM_cycles的運作必須在抓到一個PWM正緣訊號才去判斷是否已計數到P個cycle，否則持續計數，老師示範時將pwm_pos_edge = '1'放錯地方，導致計數有問題。)
  
模擬結果：https://drive.google.com/file/d/1rd36eLW7SKAc0hT_yatXky2to6aC46qC/view?usp=sharing
<img width="1123" height="395" alt="sim1" src="https://github.com/user-attachments/assets/0bd0032c-eb43-4b78-894d-dda358e0f721" />
<img width="1125" height="391" alt="sim2" src="https://github.com/user-attachments/assets/a2a445fc-5d80-44cf-a153-7d8fa43cc86a" />
<img width="1125" height="393" alt="sim3" src="https://github.com/user-attachments/assets/526629f1-de40-4e40-8223-4007789e1d39" />
<img width="1127" height="396" alt="sim4" src="https://github.com/user-attachments/assets/a27ea498-7057-4f01-a9fb-31d8b3d91c1a" />
<img width="1130" height="387" alt="sim5" src="https://github.com/user-attachments/assets/fc6d5be9-5841-4318-aa0c-56d9e4d6b524" />
<img width="1122" height="392" alt="sim6" src="https://github.com/user-attachments/assets/44ea3f46-0677-45e0-a284-e293e6a833e6" />
<img width="1125" height="388" alt="sim7" src="https://github.com/user-attachments/assets/26b9b9e8-ce7c-4da8-8571-87a1571168d4" />
<img width="1125" height="387" alt="sim8" src="https://github.com/user-attachments/assets/6250c140-cf24-48c8-8b7a-0acb9e9a18ba" />
