public class testPanel{

    public String SelectedOption { get; set; }

    public Boolean renderZ { get; set; }

    public Boolean renderY { get; set; }

    public Boolean renderX { get; set; }

    public PageReference evaluateRenderLogic() {
    if(SelectedOption == 'hello3')
        renderZ = false;
        return null;
    }

    public String inputVar {get; set;}
    public Boolean showPanel1 {get; set;}
    public testPanel() {
    renderZ = true;
        renderX = true;
            renderY = true;
        System.debug('In Constructor');
        showPanel1=false;
    }
    public void refreshPanels(){
        System.debug('In refreshPanels');
         if(inputvar!=null && inputvar=='1'){
             System.debug('In refreshPanels - IF');
             showPanel1=true;
             }
         else if(inputvar!=null && inputvar=='2'){
             System.debug('In refreshPanels- Else');
             showPanel1=false;
             }
             
             System.debug('---showPanel1----' + showPanel1);
    }
}