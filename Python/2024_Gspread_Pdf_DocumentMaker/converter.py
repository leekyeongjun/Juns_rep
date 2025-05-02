import os
import smtplib
import gspread
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from pptx import Presentation
from pptxtopdf import convert
import fitz # pip install PyMuPDF

class Bot :
    def __init__(self):
        self.key = "./auth/key.json"
        self.sheeturl = "forbidden"
        self.doc = None
        self.sheet = None
        self.sheetname = None
        self.gc = None
        self.allData = None
        
        self.smtp = None
        self.id = "forbidden"
        self.pw = "forbidden"
        self.gmail = None
        self.titletext = None
        self.contenttext = None
        
        self.originfilepath = None
        self.thumbpath = None



    def CheckAvailability(self, sheetName) :
        try:
            if self.gc is None :
                self.gc = gspread.service_account(self.key)
                if self.doc is None :
                    self.doc = self.gc.open_by_url(self.sheeturl)
        except :
            print("구글로그인에러")
            return 1
        else :
            try :
                self.sheet = self.doc.worksheet(sheetName)
                self.allData = self.sheet.get_all_values()
                self.sheetname = sheetName
            except :
                print("시트명 에러")
                return 2
            else :
                try :
                    self.gmail = smtplib.SMTP_SSL("smtp.gmail.com", 465)
                    self.gmail.login(self.id, self.pw)
                except :
                    print("메일 로그인 에러")
                    return 3

        print("모든 검사 종료")
        return 0
    
    def deleteAllFiles(self, filepath) :
        if os.path.exists(filepath):
            for file in os.scandir(filepath):
                os.remove(file.path)
        
    def Certificate_upload(self, filepath): # try 변환 필요
        
        if filepath.endswith('.pptx'):

            self.deleteAllFiles(".\\thumbs\\")

            self.originfilepath = filepath

            print(self.originfilepath)
            filename_with_extension = os.path.basename(self.originfilepath)
            print(filename_with_extension)
            filename_without_extension = os.path.splitext(filename_with_extension)[0]
            print(filename_without_extension)

            pdfpath = "./thumbs/"

            convert(filepath, pdfpath)
            thumbfile = fitz.open(pdfpath+filename_without_extension+".pdf")

            img = thumbfile[0].get_pixmap()

            self.thumbpath = f"./thumbs/{filename_without_extension}.png"
            img.save(self.thumbpath)

            return self.thumbpath
        
        else :
            return 1