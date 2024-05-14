//
//  AppCoordinator.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppCoordinator: FlowCoordinator {
    let parent: BaseCoordinator? = nil
    var children: [BaseCoordinator] = []
    let navigationController: UINavigationController
    let injected: Injected
    
    init(navigationController: UINavigationController, injected: Injected) {
        self.navigationController = navigationController
        self.injected = injected
    }
    
    // MARK: - Private
    private func configureTabController() -> UITabBarController {
        let accountModel = AccountViewModel(coordinator: self, injected: injected)
        let accountController = HostController<AccountView>(model: accountModel)
        accountController.tabBarItem = .init(
            title: "Account",
            image: .init(systemName: "person.crop.circle"),
            selectedImage: .init(systemName: "person.crop.circle.fill")
        )
        
        let sportsbookService = SportsbookService()
        let sportsbookModel = EventListModel(
            service: sportsbookService,
            urlPath: "https://618d3aa7fe09aa001744060a.mockapi.io/api/sports"
        )
        let sportsbookController = EventsViewController(model: sportsbookModel)
        
        sportsbookController.tabBarItem = .init(
            title: "Sportsbook",
            image: .init(systemName: "sportscourt.circle"),
            selectedImage: .init(systemName: "sportscourt.circle.fill")
        )
        
        let tabController = UITabBarController()
        tabController.title = "Sample App"
        tabController.setViewControllers(
            [
                sportsbookController,
                accountController
            ],
            animated: false
        )
        return tabController
    }
    
    func start() {
        navigate(to: .splash)
    }
    
    func navigate(to destination: AppFlow) {
        switch destination {
        case .splash:
            let model = SplashViewModel(coordinator: self, service: injected.authService, accountStatus: injected.accountStatus, email: injected.email)
            let controller = HostController<SplashView>(model: model)
            navigationController.push(controller)
        case .home:
            let controller = configureTabController()
            navigationController.setViewControllers([controller], animated: true)
        case .login:
            onMain{ [weak self] in
                guard let self = self else { return }
                
                let model = AuthModel(coordinator: self, service: injected.authService, variant: .signIn, email: injected.email)
                let controller = HostController<AuthView>(model: model)
                navigationController.setViewControllers([controller], animated: true)
            }

        case .register:
            onMain { [weak self] in
                guard let self = self else { return }
                
                let model = AuthModel(coordinator: self, service: injected.authService, variant: .register, email: nil)
                let controller = HostController<AuthView>(model: model)
                navigationController.push(controller)
            }
        }
    }
}

// MARK: - AccountObserver
extension AppCoordinator: AccountObserver {
    func accountUpdated(with account: Account) {
        injected.updateAccount(with: account)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.navigate(to: .home)
        }
    }
    
    func accountLoggedOut() {
        reset()
        injected.resetAccount()
        navigate(to: .login)
    }
}
