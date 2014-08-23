classdef SQLServerConnector
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SQLString;
        SQLServerName;
    end
    
    methods
        %/ Constructor
        function obj = SQLServerConnector(SQLServerName)
                 %Set preferences with setdbprefs.
                 setdbprefs('DataReturnFormat', 'cellarray');
                 setdbprefs('NullNumberRead', 'NaN');
                 setdbprefs('NullStringRead', 'null');
                 obj.SQLServerName = SQLServerName;
        end
        
        
        
        %/ download
        function DownloadData = SQLServerDownload(sSQL)
              %Make connection to database.  Note that the password has been omitted.
              %Using ODBC driver.
              conn = database('SQLServer', obj.SQLServerName, '');
 
              %Read data from database.
              curs = exec(conn, [sSQL]);
              curs = fetch(curs);
              close(curs);

              %Assign data to output variable
              DownloadData = curs.Data;

              %Close database connection.
              close(conn);

              %Clear variables
              clear curs conn
            
        end
    end
    
end

