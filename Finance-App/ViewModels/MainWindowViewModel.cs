using System.Collections.ObjectModel;
using System.Windows.Input;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Finance_App.Models.Ui;

namespace Finance_App.ViewModels;

public partial class MainWindowViewModel : ViewModelBase
{
    [ObservableProperty]
    private ObservableCollection<NavigationItem> _navigationItems;

    [ObservableProperty]
    private string _pageTitle;

    public ICommand NavigateCommand { get; }
    public MainWindowViewModel()
    {
        // Initialize navigation items
        NavigationItems = new ObservableCollection<NavigationItem>
        {
            new NavigationItem { Icon = "📊", Title = "Dashboard", Description = "Overview of your finances" },
            new NavigationItem { Icon = "💰", Title = "Investments", Description = "Portfolio details" },
            new NavigationItem { Icon = "💵", Title = "Income & Expenses", Description = "Track cash flow" },
            new NavigationItem { Icon = "💸", Title = "Expense Tracking", Description = "Daily expense management" },
            new NavigationItem { Icon = "✍️", Title = "Data Entry", Description = "Manual data input" },
            new NavigationItem { Icon = "🔍", Title = "Analysis", Description = "Advanced insights" }
        };

        // Initialize commands
        NavigateCommand = new RelayCommand<string>(NavigateToPage);

        PageTitle = "Financial Dashboard";
    }

    private void NavigateToPage(string? pageName)
    {
        if (string.IsNullOrEmpty(pageName))
            return;

        // CurrentViewModel = pageName switch
        // {
        //     "Dashboard" => new DashboardViewModel(),
        //     "Investments" => new InvestmentsViewModel(),
        //     "Income & Expenses" => new IncomeExpensesViewModel(),
        //     "Expense Tracking" => new ExpenseTrackingViewModel(),
        //     "Data Entry" => new DataEntryViewModel(),
        //     "Analysis" => new DetailedAnalysisViewModel(),
        //     _ => CurrentViewModel
        // };

        PageTitle = $"{pageName} - Financial Dashboard";
    }
}
