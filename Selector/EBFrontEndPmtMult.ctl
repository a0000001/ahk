VERSION 5.00
Object = "{765F3BE5-8C26-47D3-BC64-FE74A1F41D40}#1.1#0"; "EpicDNavigator82.ocx"
Begin VB.UserControl EBFrontEndPmtMult 
   ClientHeight    =   12105
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   17115
   ScaleHeight     =   12105
   ScaleWidth      =   17115
   Begin EDNavigator82.EDBrowser edb 
      Height          =   11760
      Left            =   135
      TabIndex        =   0
      Top             =   180
      Width           =   16845
      _ExtentX        =   29713
      _ExtentY        =   20743
      Location        =   "http:///"
      StandardMenuItems=   17
   End
End
Attribute VB_Name = "EBFrontEndPmtMult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements IEDNeedDesktop
Implements IEDControl

Private m_Desktop As IEpicDesktop
Private m_Activity As IEDActivity
Private m_Connector As IEConnector

Private m_XML As HBDisplay2


Private m_sRedirect As String

Private m_DataLoaded As Boolean

'*VN++ 05/2003 [62145] - This function has changed in HBHTMLUtil.bas. Making the change here as well...
'Although, I don't think that this should really be here....
'
'copied from HBHTMLUtil.bas to reduce dependencies
Private Function GetEpicURL(URL As String, Parameters As String) As Boolean

  If LCase$(Mid$(URL, 1, 7)) = "epic:\\" Then
    GetEpicURL = True
    'Parameters = Piece(URL, "\", 3)
    Parameters = Replace$(Right$(URL, Len(URL) - 7), "%20", " ", , , vbTextCompare)

  End If

End Function


Private Sub edb_BeforeNavigate2(ByVal WebObject As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
  Dim sURL      As String
  Dim sParams   As String
  Dim sParam()  As String
  
  sURL = CStr(URL)
    If GetEpicURL(sURL, sParams) Then
      Cancel = True

      sParam = Split(sParams, "|")   '*billv 6/06 110521

'      Select Case SplitStr(sParams, "|")
'
'      End Select
    End If
End Sub

Private Sub edb_DocumentComplete(ByVal WebObject As Object, URL As Variant)
  
  Call m_XML.GetXML(edb.document, m_Desktop, "d SetUp^XKESPFEN", True)
  
  Call m_XML.reEval
  
  
End Sub

Private Sub IEDControl_ActionAllowed(Action As Long, Problems As EDInterfaces82.IEDObjectStore)

End Sub

Private Sub IEDControl_ActiveChanged(Active As Boolean, Reason As Long, Optional Problem As EDInterfaces82.IEDProblem)

End Sub

Private Sub IEDControl_CanLoseFocus(Cancel As Boolean, Reason As Long)

End Sub

Private Sub IEDControl_CanQuit(Cancel As Boolean, QuitReason As Long)

End Sub

Private Sub IEDControl_Destroy()

End Sub

Private Function IEDControl_DoAction(Action As String, Optional Param1 As Variant, Optional Param2 As Variant) As Variant

End Function

Private Property Get IEDControl_FormCaption() As String

End Property

Private Property Get IEDControl_FormIcon() As stdole.IPictureDisp

End Property

Private Function IEDControl_GetMinMaxInfo(MinWidth As Long, MinHeight As Long, MaxWidth As Long, MaxHeight As Long) As Boolean

End Function

Private Function IEDControl_GetRect(Left As Long, Top As Long, Width As Long, Height As Long) As Boolean

End Function

Private Property Get IEDControl_InfoProvidersArray(Optional ByVal ActivityDescriptor As String, Optional ByVal LaunchOptions As Long, Optional ByVal Requestor As String) As Variant

End Property

Private Sub IEDControl_Initialize(Activity As EDInterfaces82.IEDActivity, Cancel As Boolean, InitParams As String, Optional TreeNode As EDInterfaces82.IEDTreeNode)
  Set m_XML = New HBDisplay2
'  If m_XML Is Nothing Then
'    ErrorMessage = "XML Class could not be loaded." ' GDB: Localize this later?
'  End If
  
'  If Len(ErrorMessage) > 0 Then
'    m_InitState = initFailed
'    Exit Function
'  End If

  m_sRedirect = m_XML.GetRedirectFile(m_Desktop)
  
  
End Sub

Private Sub IEDControl_MenuItemClicked(MenuItem As EDInterfaces82.IEDMenuItem)

End Sub

Private Sub IEDControl_PrintClicked(Preview As Boolean, ToolbarButton As Boolean, Descriptor As String)

End Sub

Private Sub IEDControl_RequiredItemReplaced(ItemName As String, NewItem As Variant, OldItem As Variant)

End Sub

Private Sub IEDControl_RequiredObjectChanged(ObjectName As String, TheObject As Object, Reason As Long)

End Sub

Private Sub IEDControl_RequiredObjectReplaced(ObjectName As String, NewObject As Object, OldObject As Object)

End Sub

Private Function IEDControl_Run(Optional RunParams As Variant, Optional FailureReason As String) As EDInterfaces82.EDRunStatus
'  Call edb.Navigate("http://www.google.com/")
'  Call edb.Navigate(m_Desktop.GetInstallDir(edidtData) & "\HTML\HBPOSPmtPostNew.html")

  Call LoadHTML


End Function

Private Sub LoadHTML(Optional LinkTag As String)
  Call edb.navigate(m_sRedirect & LinkTag)
End Sub

Private Sub IEDControl_RunParamsChanged(RunParams As Variant)

End Sub

Private Property Get IEDControl_Status() As Long

End Property

Private Sub IEDControl_Timeout()

End Sub

Private Property Get IEDControl_Version() As String

End Property

Private Sub IEDControl_WorkspaceUserChanged(ByVal OldUser As EDInterfaces82.IEDUser, ByVal NewUser As EDInterfaces82.IEDUser)

End Sub

Private Sub IEDControl_WorkstationChanged(ByVal OldWSID As String, ByVal NewWSID As String)

End Sub

Private Property Set IEDNeedDesktop_Desktop(RHS As EDInterfaces82.IEpicDesktop)
  Set m_Desktop = RHS
  If Not (m_Desktop Is Nothing) Then
    Set m_Connector = m_Desktop.Connector
  End If
End Property

