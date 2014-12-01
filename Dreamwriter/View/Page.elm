module Dreamwriter.View.Page where

import Dreamwriter.Model (..)
import Dreamwriter.Action as Action
import Component.LeftSidebar as LeftSidebar
import Dreamwriter.View.RightSidebar as RightSidebar
import Dreamwriter.View.Editor as Editor

import String
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel as LC

actionToLeftSidebarModel : Doc -> AppState -> LeftSidebar.Model
actionToLeftSidebarModel currentDoc model = {
    docs       = model.docs,
    currentDoc = currentDoc,
    viewMode   = case model.leftSidebarView of
      CurrentDocView -> LeftSidebar.CurrentDocMode
      OpenMenuView   -> LeftSidebar.OpenMenuMode
  }

leftSidebarToAction : LeftSidebar.Update -> Action.Action
leftSidebarToAction update =
  case update of
    LeftSidebar.NoOp -> Action.NoOp

    LeftSidebar.SetViewMode mode ->
      Action.SetLeftSidebarView <| case mode of
        LeftSidebar.CurrentDocMode -> CurrentDocView
        LeftSidebar.OpenMenuMode   -> OpenMenuView

leftSidebarUpdates : LC.LocalChannel LeftSidebar.Update
leftSidebarUpdates = LC.create leftSidebarToAction Action.actions

view : AppState -> Html
view state =
  div [id "page"] <|
    case state.currentDoc of
      Nothing -> []
      Just currentDoc ->
        [
          LeftSidebar.view  leftSidebarUpdates (actionToLeftSidebarModel currentDoc state),
          Editor.view       currentDoc state,
          RightSidebar.view currentDoc state
        ]
