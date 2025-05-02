try:
    import Tkinter as tk
except:
    import tkinter as tk

import tkinter.font as tkfont
import tkinter.ttk as ttk
import tkinter.messagebox as tkmsgbox
import tkinter.filedialog as tkfile
import threading
from PIL import Image, ImageTk 
import converter

class Converter(tk.Tk):
    def __init__(self):
        global BOT
        BOT = converter.Bot()
        global TitleImage,SheetImage, f_NOTOSANS_EB_title, f_NOTOSANS , f_NOTOSANS_SMALL

        tk.Tk.__init__(self)
        self._frame = None
        
        TitleImage = tk.PhotoImage(file = './imgs/logo.png')
        SheetImage = tk.PhotoImage(file = './imgs/sheetimg.png')
        f_NOTOSANS_EB_title = tkfont.Font(family = "Noto Sans KR Bold", size = 15)
        f_NOTOSANS = tkfont.Font(family= "Noto Sans KR", size = 10)
        f_NOTOSANS_SMALL = tkfont.Font(family= "Noto Sans KR", size = 8)

        #self.switch_frame(StartPage)
        self.switch_frame(FinalScreen)
        

    def switch_frame(self, frame_class):
        new_frame = frame_class(self)
        if self._frame is not None:
            self._frame.destroy()
        self._frame = new_frame
        self._frame.pack()

class StartPage(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)

        l_titleimg = tk.Label(self,
            image= TitleImage,
            width= 300,
            height= 300
        )

        l_title = tk.Label(self, 
            text = "에이블런 수료증 자동화 프로그램", 
            font = f_NOTOSANS_EB_title,
        )

        l_subtitle = tk.Label(self,
            text = "by Jason",
            font= f_NOTOSANS,
        )

        b_beginwork = tk.Button(self,
            text = "작업 시작",
            font= f_NOTOSANS_EB_title,
            width = 15,

            command=lambda: master.switch_frame(CheckSheet)
        )

        b_linkopen = tk.Button(self,
            text = "수료증자동화 가이드라인",
            borderwidth = 0,
            relief= 'flat',
       
            # command = 
        )

        l_titleimg.pack(fill = 'y')
        l_title.pack()
        l_subtitle.pack(pady = 15)
        b_beginwork.pack(pady = 5)
        b_linkopen.pack()

class CheckSheet(tk.Frame):

    def __init__(self, master):
        tk.Frame.__init__(self, master)
        

        l_checksheet1 = tk.Label(self,
            text = "자동화 할 시트의 이름을 기입해 주십시오.",
            font = f_NOTOSANS_EB_title,
        )

        l_sheetimg = tk.Label(self,
            image= SheetImage,
            width= 300,
            height= 300
        )
        
        self.e_sheetnameentry = tk.Entry(self,
            font = f_NOTOSANS,
            width = 25,
        )

        l_checksheet2 = tk.Label(self,
            text = "예시) 위 경우 시트 이름 : 원본시트",
            font = f_NOTOSANS_SMALL,
        )

        self.b_sheetcheck = tk.Button(self,
            font = f_NOTOSANS,
            text = "다음",
            width = 8,

            command = self.sheetName_handle
        )

        self.b_revert = tk.Button(self,
            font = f_NOTOSANS,
            text = "취소",
            width = 8,

            command=lambda: master.switch_frame(StartPage)
        )

        l_checksheet1.pack(pady = 10)
        l_sheetimg.pack(pady=15)
        self.e_sheetnameentry.pack()
        l_checksheet2.pack(pady = 5)
        self.b_sheetcheck.pack(side='right', anchor = 'e')
        self.b_revert.pack(side = 'left', anchor= 's')
    
    def show_loading(self):

        self.b_sheetcheck.config(state = tk.DISABLED)
        self.b_revert.config(state = tk.DISABLED)

        self.l_loadingModal = tk.Label(self,
            text = "로딩중 ...",
            font = f_NOTOSANS_SMALL    
        )

        self.p_loadingbar = ttk.Progressbar(self,
            maximum=100,
            mode = 'indeterminate'
        )

        self.l_loadingModal.pack()
        self.p_loadingbar.start(10)
        self.p_loadingbar.pack()
    
    def hide_loading(self):
        self.b_sheetcheck.config(state = tk.NORMAL)
        self.b_revert.config(state = tk.NORMAL)
        self.l_loadingModal.destroy()
        self.p_loadingbar.destroy()

    def check_sheet(self, userInput):
        response = BOT.CheckAvailability(userInput)
        self.hide_loading()

        if response == 1 :
            tkmsgbox.showerror(("오류"), "구글 스프레드 시트 로그인 안됨")
        elif response == 2 :
            tkmsgbox.showerror(("오류"), userInput + " 시트를 찾을수 없습니다.")
        elif response == 3 :
            tkmsgbox.showerror(("오류"), "메일 로그인 실패")
        else:
            self.master.switch_frame(CheckCertificate)

    def sheetName_handle(self):
        userInput = self.e_sheetnameentry.get()
        self.show_loading()

        threading.Thread(target =self.check_sheet, args =(userInput,)).start()

class CheckCertificate(tk.Frame):
    def __init__(self, master):
        self.thumbimage = Image.open("./imgs/thumbtest.png").resize((250,300))
        self.thumbnail_init = ImageTk.PhotoImage(self.thumbimage)

        tk.Frame.__init__(self, master)

        f_1 = tk.Frame(self,
            width = 500,
            height= 100,            
        )

        f_2 = tk.Frame(self,
            width = 500,
            height= 350,            
        )

        self.f_3 = tk.Frame(self,
            width = 500,
            height= 50,                
        )

        l_checkcerti1 = tk.Label(f_1,
            text = "원본 수료증 파일을 업로드 해 주십시오.",
            font = f_NOTOSANS_EB_title
        )

        l_sheetname = tk.Label(f_1,
            text = "시트명 : " + BOT.sheetname,
            font= f_NOTOSANS,
        )

        self.l_filepath = tk.Label(f_1,
            font = f_NOTOSANS,
            width = 35,
            background='white',
            relief='sunken'
        )

        self.b_upload = tk.Button(f_1,
            font = f_NOTOSANS,
            text = "찾아보기..",

            command = self.CheckCertiFormat                
        )

        """
        l_debug_sheetdata = tk.Label(self,
            text =  '\n'.join(['/'.join(item) for item in BOT.allData]),
            font = f_NOTOSANS_SMALL
        )
        """

        self.l_certithumb = tk.Label(f_2,
            image= self.thumbnail_init, 
            width= 250,
            height= 300
        )

        self.b_prev = tk.Button(self.f_3,
            font = f_NOTOSANS,
            text = "이전",
            width = 8,

            command=lambda: master.switch_frame(CheckSheet)
        )

        self.b_next = tk.Button(self.f_3,
            font = f_NOTOSANS,
            text = "다음",
            width = 8,

            command=self.CheckCerti
        )


        f_1.pack()
        l_checkcerti1.pack(pady = 10)
        l_sheetname.pack()

        self.l_filepath.pack(side = tk.LEFT, padx= 15, pady = 10)
        self.b_upload.pack(side = tk.RIGHT, padx= 15, pady= 10)

        f_2.pack()
        self.l_certithumb.pack()

        self.f_3.pack(pady = 10, fill = 'both')
        self.b_prev.pack(side = tk.LEFT, anchor= 's')
        self.b_next.pack(side = tk.RIGHT, anchor= 'e')
        
        #l_debug_sheetdata.pack()

    def CheckCertiFormat(self) :
        certi_path = tkfile.askopenfilename()
        if certi_path:
            self.show_loading()
            threading.Thread(target =self.SettingThumb, args =(certi_path,)).start()

    def show_loading(self):
        self.b_upload.config(state = tk.DISABLED)
        self.b_prev.config(state = tk.DISABLED)
        self.b_next.config(state = tk.DISABLED)

        self.l_loadingModal = tk.Label(self.f_3,
            text = "로딩중 ...",
            font = f_NOTOSANS_SMALL    
        )

        self.p_loadingbar = ttk.Progressbar(self.f_3,
            maximum=100,
            mode = 'indeterminate'
        )

        self.l_loadingModal.pack()
        self.p_loadingbar.start(10)
        self.p_loadingbar.pack()

    def hide_loading(self):

        self.b_upload.config(state = tk.NORMAL)
        self.b_prev.config(state = tk.NORMAL)
        self.b_next.config(state = tk.NORMAL)

        self.l_loadingModal.destroy()
        self.p_loadingbar.destroy()

    def SettingThumb(self, filepath) :
        response = BOT.Certificate_upload(filepath)
        self.hide_loading()
        if response == 1 :
            tkmsgbox.showerror("오류", "원본 수료증 파일은 .pptx 파일이어야 합니다.")
        else :
            self.thumbnail_init = ImageTk.PhotoImage(Image.open(response).resize((250,300)))
            self.l_certithumb.config(image= self.thumbnail_init)
            self.l_filepath.config(text = BOT.originfilepath)

    def CheckCerti(self) :
        if BOT.originfilepath is None :
            tkmsgbox.showerror("오류", "수료증 파일이 선택되지 않았습니다.")
        else :
            self.master.switch_frame(CheckMail)  

class CheckMail(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)

        self.f_1 = tk.Frame(self,
            width = 500,
            height = 100,
                                   
        )

        self.l_checkmail1_1 = tk.Label(self.f_1,
            text = "메일 내용을 구성합니다.",
            font = f_NOTOSANS_EB_title
        )

        self.l_checkmail1_2 = tk.Label(self.f_1,
            text = "시트 : " , #+ BOT.sheetname,
            font = f_NOTOSANS_SMALL
        )

        self.l_checkmail1_3 = tk.Label(self.f_1,
            text = "수료증 파일 : ", # + BOT.originfilepath,
            font = f_NOTOSANS_SMALL
        )

        self.f_2 = tk.Frame(self,
            width= 500,
            height = 350,
            
        )

        self.l_checkmail2_1 = tk.Label(self.f_2,
            text = "메일 제목",
            font = f_NOTOSANS
        )

        self.l_checkmail2_2 = tk.Label(self.f_2,
            text = "본문",
            font = f_NOTOSANS,
        )

        self.e_mailtitle = tk.Entry(self.f_2,
            font = f_NOTOSANS,
            width = 50,
        )

        self.mailcontentArea = tk.Frame(self.f_2,
            width = 500,
            height= 100,
        
        )

        self.s_scrollbar = tk.Scrollbar(self.mailcontentArea)

        self.e_mailcontent = tk.Text(self.mailcontentArea,
            font = f_NOTOSANS,
            width = 48,
            height = 12,
            yscrollcommand= self.s_scrollbar.set
        )

        self.s_scrollbar["command"] = self.e_mailcontent.yview

        self.f_3 = tk.Frame(self,
            width = 500,
            height= 50,
        )

        self.b_revert = tk.Button(self,
            font = f_NOTOSANS,
            text = "이전",
            width = 8,

            command=lambda: master.switch_frame(CheckCertificate)
        )

        self.b_confirm = tk.Button(self,
            font = f_NOTOSANS,
            text = "확인",
            width = 8,

            command= self.Checkmail
        )


        self.f_1.pack(pady= 10)
        self.l_checkmail1_1.pack()
        self.l_checkmail1_2.pack()
        self.l_checkmail1_3.pack()

        self.f_2.pack(pady = 10)
        self.l_checkmail2_1.pack(anchor='w')
        self.e_mailtitle.pack()
        self.l_checkmail2_2.pack(anchor='w')

        self.mailcontentArea.pack()
        self.e_mailcontent.pack(side = 'left')
        self.s_scrollbar.pack(side = 'right', fill = 'y')
        

        self.b_revert.pack(side = "left", anchor= 'w')
        self.b_confirm.pack(side = 'right', anchor= 'e')

    def Checkmail(self) :
        m_title = self.e_mailtitle.get()
        m_content = self.e_mailcontent.get("1.0", tk.END)

        if m_title == "" :
            tkmsgbox.showerror("오류", "메일의 제목이 비어있습니다.")
        elif m_content == "":
            tkmsgbox.showerror("오류", "메일의 본문이 비어있습니다.")

        else :
            BOT.titletext = m_title
            BOT.contenttext = m_content

            print(f"제목 : {m_title}")
            print(f"본문 : {m_content}")

            self.master.switch_frame(FinalScreen)

class FinalScreen(tk.Frame) :
    def __init__(self, master):
        tk.Frame.__init__(self, master)    

        self.f_1 = tk.Frame(self,
            width = 500,
            height= 60
        )
        self.f_2 = tk.Frame(self,
            width = 500,
            height= 350
        )

        self.f_2_left = tk.Frame(self.f_2,
            width = 230,
            height= 350,
             
        )

        self.l_f_2_left_1 = tk.Label(self.f_2_left,
            text = "메일 제목",
            font = f_NOTOSANS,
            anchor= 'w'
        )

        self.m_f_2_left_1 = tk.Entry(self.f_2_left,
            font = f_NOTOSANS_SMALL,
            width = 230,
            readonlybackground='white'
        )

        ###############################################################################
        self.m_f_2_left_1.insert(0, "[이경준] 2024 Ablearn 전격 개고생 수료증 전달의 건")
        self.m_f_2_left_1["state"] = "readonly"
        ###############################################################################

        self.l_f_2_left_2 = tk.Label(self.f_2_left,
            text = "본문",
            font = f_NOTOSANS,
            anchor= 'w'
        )

        self.m_f_2_left_2 = tk.Text(self.f_2_left,
            font = f_NOTOSANS_SMALL,
            relief= 'groove',
            width = 230,
        )

        ###############################################################################
        self.m_f_2_left_2.insert(1.0, """국가는 농지에 관하여 경자유전의 원칙이 달성될 수 있도록 노력하여야 하며, \n농지의 소작제도는 금지된다. 누구든지 체포 또는 구속의 이유와 변호인의 조력을 받을 권리가 있음을 고지받지 아니하고는 체포 또는 구속을 당하지 아니한다. \n체포 또는 구속을 당한 자의 가족등 법률이 정하는 자에게는 그 이유와 일시·장소가 지체없이 통지되어야 한다.계엄을 선포한 때에는 대통령은 지체없이 국회에 통고하여야 한다. \n헌법재판소 재판관은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.
국가는 농지에 관하여 경자유전의 원칙이 달성될 수 있도록 노력하여야 하며, \n농지의 소작제도는 금지된다. 누구든지 체포 또는 구속의 이유와 변호인의 조력을 받을 권리가 있음을 고지받지 아니하고는 체포 또는 구속을 당하지 아니한다. \n체포 또는 구속을 당한 자의 가족등 법률이 정하는 자에게는 그 이유와 일시·장소가 지체없이 통지되어야 한다.계엄을 선포한 때에는 대통령은 지체없이 국회에 통고하여야 한다. \n헌법재판소 재판관은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.""")
        self.m_f_2_left_2["state"] = "disabled"
        ###############################################################################

        self.f_2_right = tk.Frame(self.f_2,
            width = 230,
            height= 350,
 
        )

        self.l_f_2_right_1 = tk.Label(self.f_2_right,
            text = "시트 명",
            font = f_NOTOSANS,
            anchor= 'w'
        )

        self.m_f_2_right_1 = tk.Entry(self.f_2_right,
            font = f_NOTOSANS_SMALL,
            width = 230,
            readonlybackground='white'
        )
        
        ###############################################################################
        self.m_f_2_right_1.insert(0, "TEST")
        self.m_f_2_right_1["state"] = "readonly"
        ###############################################################################

        self.l_f_2_right_2 = tk.Label(self.f_2_right,
            text = "원본 파일 경로",
            font = f_NOTOSANS,
            anchor= 'w'
        )

        self.m_f_2_right_2 = tk.Entry(self.f_2_right,
            font = f_NOTOSANS_SMALL,
            width = 230,
            readonlybackground='white'
        )

        ###############################################################################
        self.m_f_2_right_2.insert(0,  "TEST")
        self.m_f_2_right_2["state"] = "readonly"
        ###############################################################################

        self.f_f_2_right_1 = tk.Frame(self.f_2_right,
            width = 230,
            height = 150,
            background= 'red'
        )

        self.t_keytable = ttk.Treeview(self.f_f_2_right_1,
            columns= ("키워드" , "변수"),
            show = 'headings',
            height= 5
        )

        self.t_keytable.heading("키워드",
            text = "키워드",
        )

        self.t_keytable.heading("변수",
            text = "변수",
        )

        self.t_keytable.column("키워드", width=115)
        self.t_keytable.column("변수", width=115)

        self.f_3 = tk.Frame(self,
            width = 500,
            height= 50
        )

        
        self.f_1.pack()
        self.f_1.pack_propagate(False)

        self.f_2.pack()
        self.f_2.pack_propagate(False)

        self.f_2_left.pack(side = "left", padx= 10, pady= 10)
        self.f_2_left.pack_propagate(False)

        self.l_f_2_left_1.pack(anchor='w',fill = "both")
        self.l_f_2_left_1.pack_propagate(False)

        self.m_f_2_left_1.pack(fill = "both")
        self.m_f_2_left_1.pack_propagate(False)

        self.l_f_2_left_2.pack(anchor='w', fill = "both")
        self.l_f_2_left_2.pack_propagate(False)

        self.m_f_2_left_2.pack(fill ="both", expand= True)
        self.m_f_2_left_2.pack_propagate(False)

        

        self.f_2_right.pack(side = "right",padx= 10, pady= 10)
        self.f_2_right.pack_propagate(False)

        self.l_f_2_right_1.pack(anchor='w', fill = "both")
        self.l_f_2_right_1.pack_propagate(False)

        self.m_f_2_right_1.pack(fill ="both")
        self.m_f_2_right_1.pack_propagate(False)

        self.l_f_2_right_2.pack(anchor='w', fill = "both")
        self.l_f_2_right_2.pack_propagate(False)

        self.m_f_2_right_2.pack(fill ="both")
        self.m_f_2_right_2.pack_propagate(False)

        self.f_f_2_right_1.pack(pady = 10)
        self.f_f_2_right_1.pack_propagate(False)

        self.t_keytable.pack()

        self.f_3.pack()
        self.f_3.pack_propagate(False)


if __name__ == "__main__":
    
    app = Converter()

    app.geometry("500x500+100+100")
    app.resizable(False,False)
    app.title("수료증 자동화 프로그램")
    
    app.mainloop()