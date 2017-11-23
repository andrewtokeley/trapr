//
//  RouteModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - RouteRouter API
protocol RouteRouterApi: RouterProtocol {
    func showListPicker(setupData: ListPickerSetupData)
}

//MARK: - RouteView API
protocol RouteViewApi: UserInterfaceProtocol {
    func setTitle(title: String?)
    func displayRouteName(name: String)
    func displayVisitFrequency(frequency: TimePeriod)
    func setFocusToRouteName()
    func bindToGroupedTableViewData(groupedData: GroupedTableViewDatasource<Station>)
    func displayNoSectionsText(text: String)
    func hideSectionsTableView(hide: Bool)
    func refreshSectionTableView()
    func displaySectionMenuOptionItems(optionItems: [OptionItem])
}

//MARK: - RoutePresenter API
protocol RoutePresenterApi: PresenterProtocol {
    func didSelectClose()
    func didUpdateRouteName(name: String?)
    func didSelectAddSection()
    func didSelectToChangeVisitFrequency()
    func didSelectDeleteStation(item: GroupedTableViewDatasourceItem<Station>)
    func didSelectShowSectionMenu(sectionIndex: Int)
    func didSelectMenuOptionItem(item: OptionItem)
}

//MARK: - RouteInteractor API
protocol RouteInteractorApi: InteractorProtocol {
    func saveRoute(route: Route)
}