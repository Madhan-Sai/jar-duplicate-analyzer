/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    public void contextInitialized(ServletContextEvent sce) {
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

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        
    }
}
