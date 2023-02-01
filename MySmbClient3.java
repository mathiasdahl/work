import jcifs.config.PropertyConfiguration;
import jcifs.context.BaseContext;
import java.util.Properties;
import java.io.*;
import java.util.*;
import jcifs.smb.*;
import jcifs.*;
import jcifs.Config;

public class MySmbClient {

   static long start;

   private static void resetTime () {
      start = System.currentTimeMillis();
   }

   private static void log (String text) {
      System.out.println ("LOG: " + text);
   }

   private static void logTime (String text) {
      log (text + " took " + (System.currentTimeMillis() - start) + " ms");
      resetTime ();
   }

   public static void main (String args[]) throws Exception
   {

      Properties properties = System.getProperties();
      
      resetTime();
      
      if (args.length < 4) {
         System.out.println ("\n" +
                             "Usage: MySmbClient PATH DOMAIN USERNAME PASSWORD [LINESTOWRITE]\n\n" +
                             "" +
                             "PATH example: smb://cmbpde1697/docmanshare/test.txt\n\n" +
                             "" +
                             "DOMAIN can be sent in empty using \"\"\n" +
                             "" +
                             "LINESTOWRITE defaults to 10. Each line is 100 bytes long.\n");

      } else {

         resetTime ();

         String path   = args[0];
         String domain = args[1];
         String user   = args[2];
         String pass   = args[3];
         int linesToWrite = 10;

         logTime ("declarations");

         String textToWrite = "This line is 100 bytes long........................................................................\n";

         if (args.length > 4)
            linesToWrite = Integer.parseInt(args[4]);

         logTime ("args check");

         log ("jcifs.util.loglevel = " + properties.getProperty("jcifs.util.loglevel"));

         logTime("get loglevel");

         BaseContext context = new BaseContext(new PropertyConfiguration(properties));

         logTime ("create context");

         SmbFile smbFile = new SmbFile(path, context.withCredentials(new NtlmPasswordAuthenticator(domain, user, pass)));

         logTime ("new SmbFile");

         SmbFileOutputStream smbfos = new SmbFileOutputStream(smbFile);

         logTime ("new SmbFileOutputStream");

         for (int i = 0; i < linesToWrite; i++) {
            smbfos.write(textToWrite.getBytes());
         }

         logTime ("writing " + (linesToWrite * textToWrite.length()) + " bytes");

         System.out.println("Successfully wrote some text to " + path);
      }
   }

}
