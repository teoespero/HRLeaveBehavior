select 
	rtrim(DistrictAbbrev) 
from tblDistrict

-- Leave Types
Select tblLeaveType.LeaveTypeiD, LeaveType,
Case When TLC.LeaveTypeCategoryID = 14 then 'Attendance' Else
    Case when TLC.LeaveTypeCategoryID IN(11) then
        Case When TLC.Multiplier < 1  then LeaveTypeCategory else 'Payout (Employee Rate)' end
    else
      LeaveTypeCategory
    end
End as Type,
Case When TLC.LeaveTypeCategoryID =14 then '' else
    Case when TLC.LeaveTypeCategoryID IN(11,58,119) then
        Case When TLC.Multiplier < 1  then 'Deduction' else 'Payout' end
    else
        Case When TLC.Multiplier < 1  then 'Increase' else 'Decrease' end
    end
end as Behavior,
Case when DOOnly =1 then 'True' else ''end as [District Office Only],
Case when DOAudit =1 then 'True' else '' end as Audit
   
FROM TblLeaveType
INNER JOIN tblLeaveTypeByCategory TLC ON tblLeaveType.LeaveTypeid = TLC.LeaveTypeid
INNER JOIN tblLeaveTypeCategory ON TLC.LeaveTypeCategoryID = tblLeaveTypeCategory.LeaveTypeCategoryID
where tblLeaveType.LeaveTypeiD Not IN(Select tblLeaveType.LeaveTypeID FROM TblLeaveType INNER JOIN tblLeaveTypeByCategory TLC ON tblLeaveType.LeaveTypeid = TLC.LeaveTypeid
Where TLC.LeaveTypeCategoryID IN(18,3,5,6,7,13,2,1,26,27,150)) and TLC.LeaveTypeCategoryid <> 12 and Inactive =0
Order by tblLeaveType.LeaveType,Case When TLC.LeaveTypeCategoryID = 14 then 'Attendance' Else
    Case when TLC.LeaveTypeCategoryID IN(11) then
        Case When TLC.Multiplier < 1  then LeaveTypeCategory else 'Payout (Employee Rate)' end
    else
      LeaveTypeCategory
    end
End,TLC.LeaveTypeCategoryID
  
  
-- Balances
Select LTC.LeaveTypeCategoryID, LTC.LeaveTypeCategory LeaveCategory, SortOrder, Case when ParentCategoryid > 0 then PLTC.LeaveTypeCategory else ' ' end as ParentCategory FROM tblleavetypecategorybydistrict LTCD
INNER JOIN tblLeaveTypeCategory LTC ON LTC.LeaveTypeCategoryID = LTCD.LeaveTypeCategoryid
LEFT JOIN tblLeaveTypeCategory PLTC ON PLTC.LeaveTypeCategoryID = LTCD.ParentCategoryid
Order by SortOrder
  
-- System Leave Types
Select tblLeaveType.LeaveTypeiD, LeaveType,
LeaveTypeCategory as Type,
Case TLC.LeaveTypeCategoryID
When 14 then 'Attendance'
When 13 then Case When TLC.Multiplier < 1  then 'Increase' else 'Decrease' end
When 5 then 'EWA Transaction'
When 10 then Case When TLC.Multiplier < 1  then 'Increase' else 'Decrease' end
When 3  then 'Cert Sub Rate'
When 18 then 'Class Sub Rate'
When 150 then 'Employee Hourly Sub Rate'
When 26 then 'Certificated EWA Rate Hourly'
When 27 then 'Certificated EWA Daily Hourly'
When 2 then 'System'
When 1 then 'System'
When 6 then 'System'
When 7 then 'System'
end as Behavior,
Case When TLC.LeaveTypeCategoryID IN(3,18,26,27,150) then DailyRate end as Rate
    
FROM TblLeaveType
INNER JOIN tblLeaveTypeByCategory TLC ON tblLeaveType.LeaveTypeid = TLC.LeaveTypeid
INNER JOIN tblLeaveTypeCategory ON TLC.LeaveTypeCategoryID = tblLeaveTypeCategory.LeaveTypeCategoryID
where tblLeaveType.LeaveTypeiD IN(Select tblLeaveType.LeaveTypeID FROM TblLeaveType INNER JOIN tblLeaveTypeByCategory TLC ON tblLeaveType.LeaveTypeid = TLC.LeaveTypeid
Where TLC.LeaveTypeCategoryID IN(18,3,5,6,7,13,2,1,26,27,150)) and TLC.LeaveTypeCategoryid <> 12 and Inactive =0
Order by tblLeaveType.LeaveType,LeaveTypeCategory,  TLC.LeaveTypeCategoryID