//This class is being used in POCProject vf page for controlling a dropdown

public class DropdownController {
    public List<SelectOption> allOptions { get; private set; }
    public List<SelectOption> visibleOptions { get; private set; }
    public String selectedOption { get; set; }

    public DropdownController() {
        // Initialize the options
        allOptions = new List<SelectOption>();
        for(Integer i = 1; i <= 15; i++) {
            allOptions.add(new SelectOption('Option' + i, 'Option ' + i));
        }
        
        // Initially show only the first 5 options
        visibleOptions = new List<SelectOption>();
        for(Integer i = 0; i < 5; i++) {
            visibleOptions.add(allOptions[i]);
        }
    }

    public void showMoreOptions() {
        // Display all options when button is clicked
        visibleOptions = allOptions;
    }

    // Method to handle the selection change
    @RemoteAction
    public static void updateSelectedOption(String selectedValue) {
        // Placeholder for additional logic if needed
    }
}

