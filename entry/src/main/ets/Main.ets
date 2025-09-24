import { InsertOperationBuilder } from './features/add/ui/InsertOperation';
import { AuthPageBuilder } from './features/auth/ui/AuthPage';
import { DashboardPageBuilder } from './features/dashboard/ui/DashboardPage';

@Entry
@Component
struct MainApp {
  @Provide('NavPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === 'AuthPage') {
      AuthPageBuilder();
    } else if (name === 'DashboardPage') {
      DashboardPageBuilder();
    } else if (name === 'InsertOperation') {
      InsertOperationBuilder();
    }
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        AuthPageBuilder()
      }
    }
    .width('100%')
    .height('100%')
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
    .navDestination(this.PageMap)
  }
}
