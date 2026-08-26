-- تحميل مكتبة Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- إنشاء النافذة الرئيسية (تتوافق تلقائياً مع الموبايل والبيسي)
local Window = Rayfield:CreateWindow({
   Name = "MM2 | Ultimate Hub",
   LoadingTitle = "جاري تحميل السكربت...",
   LoadingSubtitle = "بواسطة Vega Script",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MM2Config",
      FileName = "Settings"
   },
   KeySystem = false -- تعطيل نظام المفاتيح لسهولة الاستخدام
})

-- إنشاء تبويب التجميع التلقائي (Main Tab)
local MainTab = Window:CreateTab("Auto Farm", 4483362458) -- أيقونة التبويب
local Section = MainTab:CreateSection("إعدادات التجميع")

-- متغيرات التحكم بحالة السكربت
local AutoFarmEnabled = false
local FarmSpeed = 25

-- مفتاح التشغيل والإيقاف (Toggle)
local Toggle = MainTab:CreateToggle({
   Name = "تشغيل التجميع التلقائي (Auto Farm)",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
       AutoFarmEnabled = Value
       if Value then
           -- تشغيل التجميع في خيط منفصل (Thread) لتجنب تجمد اللعبة
           task.spawn(function()
               local Players = game:GetService("Players")
               local TweenService = game:GetService("TweenService")
               local LocalPlayer = Players.LocalPlayer

               while AutoFarmEnabled do
                   local character = LocalPlayer.Character
                   if character and character:FindFirstChild("HumanoidRootPart") then
                       -- البحث عن مجلد العملات داخل الخريطة الحالية
                       local coinContainer = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("CoinContainer")
                       
                       if coinContainer then
                           for _, coin in pairs(coinContainer:GetChildren()) do
                               if not AutoFarmEnabled then break end
                               
                               -- التحقق من وجود العملة وصحتها
                               if coin:IsA("BasePart") or coin:FindFirstChild("TouchInterest") then
                                   local hrp = character.HumanoidRootPart
                                   local distance = (hrp.Position - coin.Position).Magnitude
                                   
                                   -- حساب الوقت بناءً على السرعة المحددة لضمان السلاسة
                                   local tweenInfo = TweenInfo.new(distance / FarmSpeed, Enum.EasingStyle.Linear)
                                   local tween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame})
                                   
                                   tween:Play()
                                   tween.Completed:Wait()
                               end
                           end
                       end
                   end
                   task.wait(0.5) -- مهلة زمنية لحماية الأداء ومنع التعليق
               end
           end)
       end
   end,
})

-- شريط التحكم بالسرعة (Slider)
local Slider = MainTab:CreateSlider({
   Name = "سرعة التنقل (Tween Speed)",
   Range = {10, 50},
   Increment = 1,
   Suffix = "Studs/sec",
   CurrentValue = 25,
   Flag = "FarmSpeedSlider",
   Callback = function(Value)
       FarmSpeed = Value
   end,
})

-- تبويب الإعدادات العامة
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateButton({
   Name = "إغلاق الواجهة",
   Callback = function()
       Rayfield:Destroy()
   end,
})

