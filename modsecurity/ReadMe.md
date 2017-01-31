## Summary
ModSecurity for IIS. From Trustwave Spiderlabs https://github.com/SpiderLabs/ModSecurity

ModSecurity is an open source, cross platform web application firewall (WAF) developed by Trustwave's SpiderLabs. It has a robust event-based programming language which provides protection from a range of attacks against web applications and allows for HTTP traffic monitoring, logging and real-time analysis. With over 10,000 deployments world-wide, ModSecurity is the most widely deployed WAF in existence.

Please note: When installing for IIS, you must add the following line to the modsecurity_iis.conf file or POST requests to ASP.NET will be blank in IIS.
    SecStreamInBodyInspection On
    
