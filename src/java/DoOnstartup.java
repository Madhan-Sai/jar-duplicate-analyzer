/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeUnit.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author Administrator
 */
public class DoOnstartup implements ServletContextListener {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     */

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        deleteFolders d=new deleteFolders(sce);
        d.deleteAllFolders();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        
    }
}

class deleteFolders{
    private final ScheduledExecutorService sec;
    ServletContextEvent sce;

    public deleteFolders(ServletContextEvent sce) {
        this.sec = Executors.newScheduledThreadPool(1);
        this.sce = sce;
    }
    
    public void deleteAllFolders(){
        final Runnable deleteF=new Runnable() {
            @Override
            public void run() {
                ServletContext sc=sce.getServletContext();
                String filepath = sc.getInitParameter("destLocation");
                String filep = sc.getInitParameter("JsonLocation");
                String dirp=System.getProperty("user.dir");
                filepath=dirp+filepath;
                filep=dirp+filep;
                File f=new File(filepath);
                File fp=new File(filep);
                try {
                    FileUtils.deleteDirectory(f);
                    FileUtils.deleteDirectory(fp);
                } catch (IOException ex) {
                Logger.getLogger(DoOnstartup.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        };
        final ScheduledFuture<?> delhandle=sec.scheduleAtFixedRate(deleteF, 1, 0, TimeUnit.MINUTES);
        sec.schedule(new Runnable(){
            @Override
            public void run() {
                delhandle.cancel(true);
            }
        }, 60*60, TimeUnit.SECONDS);
    }
}
