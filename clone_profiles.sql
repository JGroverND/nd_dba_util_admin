--
-- CLONE PROFILES
-- -------------------------------------
Begin
  declare
  Cursor C1 Is 
  Select Distinct Profile 
    From Dba_Profiles 
   Order By 1;
   
  Cursor C2 (P_Profile In Varchar2) Is 
  Select Resource_Name, Limit 
    From Dba_Profiles 
   Where Profile = P_Profile 
   Order by resource_type, resource_name;
  
  Begin
  
  For R1 In C1 Loop
    dbms_output.put_line('-- -------------------------------------');
    Dbms_Output.Put_Line('CREATE PROFILE ' || R1.Profile || ' LIMIT');
    
    For R2 In C2(R1.Profile) Loop
      Dbms_Output.Put_Line(r2.Resource_name || ' ' || r2.Limit);
    End Loop;
    
    Dbms_Output.Put_Line(';');
  End Loop;
  End;
End;
