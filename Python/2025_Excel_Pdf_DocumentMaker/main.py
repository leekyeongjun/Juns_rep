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
        global f_NOTOSANS_EB_title, f_NOTOSANS , f_NOTOSANS_SMALL

        tk.Tk.__init__(self)
        self._frame = None
        
        f_NOTOSANS_EB_title = tkfont.Font(family = "Noto Sans KR Bold", size = 20)
        f_NOTOSANS = tkfont.Font(family= "Noto Sans KR", size = 14)
        f_NOTOSANS_SMALL = tkfont.Font(family= "Noto Sans KR", size = 10)

        
        self.switch_frame(P_INIT)

    def switch_frame(self, frame_class):
        new_frame = frame_class(self)
        if self._frame is not None:
            self._frame.destroy()
        self._frame = new_frame
        self._frame.pack(fill=tk.BOTH, expand=True)
    
class P_INIT(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.place(relwidth=1, relheight=1)
        
        self.IMG_TITLE = ImageTk.PhotoImage(Image.open("./imgs/logo.png").resize((500,300)))

        self.L_TITLEIMG = tk.Label(self,
            image= self.IMG_TITLE,
            width= 500,
            height= 300,
            
        ).place(x = 150, y = 10)

        self.L_TITLE = tk.Label(self, 
            text = "XLSX to PDF DOCUMENT GENERATOR", 
            font = f_NOTOSANS_EB_title,
        ).place(x = 150, y = 350)

        self.L_SUBTITLE = tk.Label(self,
            text = "NaiveProgrammer",
            font= f_NOTOSANS,
        ).place(x = 300, y = 400)

        self.B_BEGINWORK = tk.Button(self,
            text = "Start",
            font= f_NOTOSANS_EB_title,

            command=lambda: master.switch_frame(P_UPLOADXLSX)
        ).place(x = 350, y = 450)


class P_UPLOADXLSX(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.place(relwidth=1, relheight=1)
        self.SetInitialStatus()

        self.L_TITLE = tk.Label(self,
            text = "Upload XLSX File",
            font = f_NOTOSANS_EB_title,                        
        )

        self.B_UPLOADXLSX = tk.Button(self,
            font = f_NOTOSANS_SMALL,
            text = "Browse..",
            command= self.CheckFilePath
        )

        self.L_FILEPATH = tk.Entry(self,
            font = f_NOTOSANS_SMALL,
            width = 50,
            background='white',
            state= 'readonly',
            readonlybackground= 'white'
        )

        self.L_TITLE_2 = tk.Label(self,
            text = "Choose the Direction of Data",
            font = f_NOTOSANS_EB_title,                        
        )

        self.IMG_HOR = ImageTk.PhotoImage(Image.open("./imgs/HOR.png").resize((200,150)))
        self.IMG_VER = ImageTk.PhotoImage(Image.open("./imgs/VER.png").resize((200,150)))

        self.B_HOR = tk.Button(self,
            text = "Horizontal",
            image=self.IMG_HOR,
            compound="bottom",
            font = f_NOTOSANS,
            borderwidth=4,
            command= lambda:self.SetDataType(1)
        )

        self.B_VER= tk.Button(self,
            text = "Vertical",
            image=self.IMG_VER,
            font = f_NOTOSANS,
            compound="bottom",
            borderwidth=4,
            command = lambda:self.SetDataType(2)
        )

        self.B_NEXT = tk.Button(self,
            font = f_NOTOSANS,
            text = "Next",
            command = self.CheckAvailabiltiy
        )

        self.B_PREV = tk.Button(self,
            font = f_NOTOSANS,
            text = "Prev",
            command=lambda:master.switch_frame(P_INIT)
        )

        self.L_TITLE.place(x = 0, y = 10, width = 800)
        self.B_UPLOADXLSX.place(x = 550, y = 100, width = 100, height= 40)
        self.L_FILEPATH.place(x = 150, y = 100, height= 40)
        self.L_TITLE_2.place(x=0, y=200, width=800)
        self.B_HOR.place(x = 150, y = 250, width=250, height=250)
        self.B_VER.place(x= 400, y = 250, width=250, height=250)
        self.B_NEXT.place(x = 690, y = 530, width= 100, height= 60)
        self.B_PREV.place(x = 10, y = 530, width= 100, height= 60)


    def CheckFilePath(self):
        xlsx_path = tkfile.askopenfilename()
        if xlsx_path:
            self.ShowLoading()
            threading.Thread(target=self.SettingPath, args=(xlsx_path,)).start()

    def ShowLoading(self):
        self.B_UPLOADXLSX.config(state = tk.DISABLED)
        self.B_PREV.config(state = tk.DISABLED)
        self.B_NEXT.config(state = tk.DISABLED)
        self.B_HOR.config(state = tk.DISABLED)
        self.B_VER.config(state= tk.DISABLED)

        self.L_LOADINGTEXT = tk.Label(self,
            text = "Now Loading...",
            font = f_NOTOSANS_SMALL    
        )

        self.PB_LOADINGBAR = ttk.Progressbar(self,
            maximum=100,
            mode = 'indeterminate'
        )

        self.L_LOADINGTEXT.place(x = 350, y = 530)
        self.PB_LOADINGBAR.start(10)
        self.PB_LOADINGBAR.place(x = 350, y = 560)
    
    def Hideloading(self):

        self.B_NEXT.config(state = tk.NORMAL)
        self.B_PREV.config(state = tk.NORMAL)
        self.B_UPLOADXLSX.config(state = tk.NORMAL)
        self.B_HOR.config(state = tk.NORMAL)
        self.B_VER.config(state= tk.NORMAL)
        self.PB_LOADINGBAR.destroy()
        self.L_LOADINGTEXT.destroy()

    def SettingPath(self, filepath) :
        response = BOT.SetWorkBook(filepath)
        self.Hideloading()

        if response == 1 :
            tkmsgbox.showerror("Error", ".xlsx or .xlsm file required.")
            self.L_FILEPATH['state'] = "normal"
            self.L_FILEPATH.delete(0,tk.END)
            self.L_FILEPATH['state'] = "readonly" 
        elif response == 2 :
            tkmsgbox.showerror("Error", "Unknown error.")
            self.L_FILEPATH['state'] = "normal"
            self.L_FILEPATH.delete(0,tk.END)
            self.L_FILEPATH['state'] = "readonly" 
        else :
            self.L_FILEPATH['state'] = "normal"
            self.L_FILEPATH.delete(0,tk.END)
            self.L_FILEPATH.insert(0, BOT.xl_fileName)
            self.L_FILEPATH.xview(tk.END)
            self.L_FILEPATH['state'] = "readonly"    

    def SetDataType(self, id):
        if id == 1:
            print("HOR")
            self.B_HOR.config(relief="sunken")
            self.B_VER.config(relief="raised")
            BOT.dataType=1  
        else :
            print("VER")
            self.B_HOR.config(relief="raised")
            self.B_VER.config(relief="sunken")
            BOT.dataType=2

    def SetInitialStatus(self):
        BOT.xl_fileName = None
        BOT.xl_workbook = None
        BOT.allData = []
        BOT.dataType = 0

    def CheckAvailabiltiy(self):
        if BOT.xl_workbook == None:
            tkmsgbox.showerror("Error", ".xlsx or .xlsm file required.")
        elif BOT.dataType == 0:
            tkmsgbox.showerror("Error", "You must select the direction of Data")
        else:
            BOT.ShowAllData()
            self.master.switch_frame(P_SELECTSHEET)

class P_SELECTSHEET(tk.Frame): # 예외처리 필요함.
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.place(relwidth=1, relheight=1)

        self.allSheetNames = BOT.xl_workbook.sheetnames
        BOT.allData = []
        BOT.xl_sheetNames = []

        self.var_list = [tk.IntVar() for _ in self.allSheetNames]

        self.L_TITLE = tk.Label(self,
            text = "Select all the sheets you want to create the document.",
            font = f_NOTOSANS_EB_title,                        
        )  

        self.L_SUBTITLE = tk.Label(self,
            text = "All data in the sheet must be directed the same.",
            font = f_NOTOSANS,                        
        )  

        self.B_NEXT = tk.Button(self,
            font = f_NOTOSANS,
            text = "Next",
            command = self.confirm_selection
        )

        self.B_PREV = tk.Button(self,
            font = f_NOTOSANS,
            text = "Prev",
            command=lambda:master.switch_frame(P_UPLOADXLSX)
        )

        # 프레임과 캔버스, 스크롤바 생성
        self.F_LISTFRAME = tk.Frame(self, 
            borderwidth=2, 
            relief=tk.GROOVE)  # 외곽선 추가
        
        self.F_LISTFRAME.place(x=200, y=150)  # 위치 설정

        self.C_LISTCANVAS = tk.Canvas(self.F_LISTFRAME)

        self.S_SCROLLBAR = tk.Scrollbar(self.F_LISTFRAME, 
            orient="vertical", 
            command=self.C_LISTCANVAS.yview
        )
        
        self.SF_SCROLLFRAME = tk.Frame(self.C_LISTCANVAS)

        # 스크롤 가능한 프레임 설정
        self.SF_SCROLLFRAME.bind(
            "<Configure>",
            lambda e: self.C_LISTCANVAS.configure(
                scrollregion=self.C_LISTCANVAS.bbox("all")
            )
        )

        self.C_LISTCANVAS.create_window((0, 0), window=self.SF_SCROLLFRAME, anchor="nw")

        # 스크롤바와 캔버스 배치
        self.C_LISTCANVAS.configure(yscrollcommand=self.S_SCROLLBAR.set)
        self.C_LISTCANVAS.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.S_SCROLLBAR.pack(side=tk.RIGHT, fill=tk.Y)

        # 체크버튼을 추가
        for i, name in enumerate(self.allSheetNames):
            checkbutton = tk.Checkbutton(self.SF_SCROLLFRAME, 
                text=name, 
                variable=self.var_list[i],
                font = f_NOTOSANS_SMALL
            )
            checkbutton.pack(anchor='w',padx=5, pady=5)  # 왼쪽 정렬

        self.L_TITLE.place(x = 0, y = 10, width = 800)
        self.L_SUBTITLE.place(x = 0, y = 50, width = 800)
        self.B_NEXT.place(x = 690, y = 530, width= 100, height= 60)
        self.B_PREV.place(x = 10, y = 530, width= 100, height= 60)

    def confirm_selection(self):
        selected_indices = [i for i, var in enumerate(self.var_list) if var.get() == 1]
        if(len(selected_indices) == 0):
            tkmsgbox.showerror("Error", "You Should Select at least one Sheet")
        
        else:
            print("선택된 인덱스:", selected_indices)
            BOT.SetAllData(selected_indices)
            #BOT.ShowAllData()
            self.master.switch_frame(P_SELECTAREA)

class P_SELECTAREA(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.place(relwidth=1, relheight=1)

        BOT.xl_sheetScopes = []
        self.all_data = BOT.allData
        self.sheet_names = BOT.xl_sheetNames

        self.frame = tk.Frame(self, relief=tk.GROOVE, borderwidth=2)
        self.frame.place(x=50, y=150, width=700, height=350)

        # 캔버스와 스크롤바 생성
        self.canvas = tk.Canvas(self.frame, highlightthickness=0)
        self.scrollbar = tk.Scrollbar(self.frame, orient="vertical", command=self.canvas.yview)
        self.scrollable_frame = tk.Frame(self.canvas)

        # 스크롤 가능한 프레임 설정
        self.scrollable_frame.bind(
            "<Configure>",
            lambda e: self.canvas.configure(
                scrollregion=self.canvas.bbox("all")
            )
        )
        self.canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")

        # 스크롤바와 캔버스 배치
        self.canvas.configure(yscrollcommand=self.scrollbar.set)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        # 제목 행 추가
        tk.Label(self, text="Sheet Name", font=f_NOTOSANS_SMALL, background="lightgray").place(x = 50, y=120, width=200)
        tk.Label(self, text="Start", font=f_NOTOSANS_SMALL, background="lightgray").place(x = 250, y=120, width=250)
        tk.Label(self, text="End",font=f_NOTOSANS_SMALL,background="lightgray").place(x = 450, y=120, width= 300)

        # 데이터 행 추가
        self.comboboxes = []  # Comboboxes 저장할 리스트
        for selected_data in self.all_data:
            row = tk.Frame(self.scrollable_frame, relief=tk.GROOVE, bg="white", borderwidth=2)
            row.pack(padx = 5, pady= 5)

            # Sheet Name
            sheet_name_label = tk.Entry(row, bg = "white")
            sheet_name_label.insert(0,self.sheet_names[self.all_data.index(selected_data)])
            sheet_name_label.config(state="readonly")
            sheet_name_label.pack(side=tk.LEFT, padx= 30, pady=20)

            # Combobox Start
            combined_start_options = []
            for option in selected_data :
                #print(str(option[0]) + "...")
                combined_start_options.append(str(option[0]) + " | " + str(option[1]) + "...")
            print(combined_start_options)


            # Combobox End
            combined_end_options = combined_start_options[:]

            combobox_start = ttk.Combobox(row, values=combined_start_options,width= 20, state="readonly")  # 읽기 전용으로 설정
            combobox_start.pack(side=tk.LEFT, padx= 30, pady=5)
            combobox_end = ttk.Combobox(row, values=combined_end_options, width= 20, state="readonly")  # 읽기 전용으로 설정
            combobox_end.pack(side=tk.LEFT, padx= 35, pady=5)

            self.comboboxes.append((combobox_start, combobox_end))  # Comboboxes 저장

        self.L_TITLE = tk.Label(self,
            text = "Set the range of data you want to generate the document.",
            font = f_NOTOSANS_EB_title,                        
        )  

        self.L_SUBTITLE = tk.Label(self,
            text = "You must exclude subject columns or rows.",
            font = f_NOTOSANS,                        
        )  
        self.B_NEXT = tk.Button(self, 
            text="Confirm", 
            command=self.confirm_selection
        )

        self.B_PREV = tk.Button(self,
            font = f_NOTOSANS,
            text = "Prev",
            command=lambda:master.switch_frame(P_SELECTSHEET)
        )        
        
        self.L_TITLE.place(x = 0, y = 10, width = 800)
        self.L_SUBTITLE.place(x = 0, y = 50, width = 800)
        self.B_PREV.place(x = 10, y = 530, width= 100, height= 60)
        self.B_NEXT.place(x = 690, y = 530, width= 100, height= 60)

    def confirm_selection(self):
        for i, (combobox_start, combobox_end) in enumerate(self.comboboxes):
            selected_start = combobox_start.current()
            selected_end = combobox_end.current()

            # 임시 배열에 추가
            if selected_start != -1 and selected_end != -1:
                start_index = selected_start
                end_index = selected_end
                # sheet_scopes에 추가
                BOT.xl_sheetScopes.append((start_index, end_index))

        print("Updated sheet scopes:", BOT.xl_sheetScopes)
        self.master.switch_frame(P_UPLOADPPTX)

class P_UPLOADPPTX(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.place(relwidth=1, relheight=1)
        self.IMG_THUMB = ImageTk.PhotoImage(Image.open("./imgs/thumbtest.png").resize((252,356)))
        BOT.pp_fileName=None
        BOT.pp_workslide=None

        self.L_TITLE = tk.Label(self,
            text = "Upload PPTX File",
            font = f_NOTOSANS_EB_title,                        
        )

        self.B_UPLOADPPTX = tk.Button(self,
            font = f_NOTOSANS_SMALL,
            text = "Browse..",
            command= self.CheckFilePath
        )

        self.L_FILEPATH = tk.Entry(self,
            font = f_NOTOSANS_SMALL,
            width = 50,
            background='white',
            state= 'readonly',
            readonlybackground= 'white'
        )

        self.B_NEXT = tk.Button(self,
            font = f_NOTOSANS,
            text = "Next",
            command = self.CheckAvailabiltiy
        )

        self.B_PREV = tk.Button(self,
            font = f_NOTOSANS,
            text = "Prev",
            command=lambda:master.switch_frame(P_SELECTAREA)
        )

        self.L_THUMBNAIL = tk.Label(self,
            image = self.IMG_THUMB,
            width = 252,
            height = 356
        )

        self.L_TITLE.place(x = 0, y = 10, width = 800)
        self.B_UPLOADPPTX.place(x = 550, y = 100, width = 100, height= 40)
        self.L_FILEPATH.place(x = 150, y = 100, height= 40)
        self.B_NEXT.place(x = 690, y = 530, width= 100, height= 60)
        self.B_PREV.place(x = 10, y = 530, width= 100, height= 60)   
        self.L_THUMBNAIL.place(x= 260, y = 150)

    def CheckFilePath(self):
        pptx_path = tkfile.askopenfilename()
        if pptx_path:
            self.ShowLoading()
            threading.Thread(target=self.SettingPath, args=(pptx_path,)).start()

    def ShowLoading(self):
        self.B_UPLOADPPTX.config(state = tk.DISABLED)
        self.B_PREV.config(state = tk.DISABLED)
        self.B_NEXT.config(state = tk.DISABLED)

        self.L_LOADINGTEXT = tk.Label(self,
            text = "Now Loading...",
            font = f_NOTOSANS_SMALL    
        )

        self.PB_LOADINGBAR = ttk.Progressbar(self,
            maximum=100,
            mode = 'indeterminate'
        )

        self.L_LOADINGTEXT.place(x = 350, y = 530)
        self.PB_LOADINGBAR.start(10)
        self.PB_LOADINGBAR.place(x = 350, y = 560)
    
    def Hideloading(self):

        self.B_NEXT.config(state = tk.NORMAL)
        self.B_PREV.config(state = tk.NORMAL)
        self.B_UPLOADPPTX.config(state = tk.NORMAL)
        self.PB_LOADINGBAR.destroy()
        self.L_LOADINGTEXT.destroy()

    def SettingPath(self, filepath) :
        response = BOT.SetPPTX(filepath)
        self.Hideloading()

        if response == 1 :
            tkmsgbox.showerror("Error", ".pptx file required.")
            self.L_FILEPATH['state'] = "normal"
            self.L_FILEPATH.delete(0,tk.END)
            self.L_FILEPATH['state'] = "readonly" 
        else :
            self.L_FILEPATH['state'] = "normal"
            self.IMG_THUMB = ImageTk.PhotoImage(Image.open(response).resize((252,356)))
            self.L_THUMBNAIL.config(image= self.IMG_THUMB)
            self.L_FILEPATH.delete(0,tk.END)
            self.L_FILEPATH.insert(0, BOT.pp_fileName)
            self.L_FILEPATH.xview(tk.END)
            self.L_FILEPATH['state'] = "readonly"    


    def CheckAvailabiltiy(self):
        if BOT.pp_workslide == None:
            tkmsgbox.showerror("Error", ".pptx file required.")
        else:
            self.master.switch_frame(P_SELECTKEYWORD)

if __name__ == "__main__":
    
    app = Converter()
    app.geometry("800x600+250+50")
    app.resizable(False,False)
    app.title("XlToPdf")
    
    app.mainloop()