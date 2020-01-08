*** Settings ***
Resource  ../Resources/DB/Postgres.robot
Resource  ../Resources/API/KiteBE.robot
Resource  ../Resources/PO/LandingPage.robot
Resource  ../Resources/PO/GlobalHeader.robot
Resource  ../Resources/PO/Login.robot
Resource  ../Resources/PO/MBO.robot
Resource  ../Resources/PO/MBO.robot
Resource  ../Resources/PO/YourObjective.robot
Resource  ../Resources/PO/ManageTarget.robot

*** Keywords ***
Home Screen
    GlobalHeader.Verify Global Header Show
    GlobalHeader.Verify Tab OKR Active

Open Tab MBO
    Common.Close Dialog Trial
    GlobalHeader.Go To MBO
    MBO.Switch MBO Iframe
    MBO.Verify MBO Menu Left Side

View Detail Evaluation Input Again
    View Detail Evaluation Input First Time
    YourObjective.Verify Page Evaluation Input Again

Your Objective
    MBO.Go To Your Objective
    MBO.Get List Event Event Name
    MBO.View Detail Evaluation Input

Action Evaluation Input
    MBO.Go To Your Objective
    MBO.Get List Event Event Name
    MBO.Evaluation Action

Manager Target
    MBO.Go To Manager Target
    ManageTarget.Verify Button Details Disable
    ManageTarget.Select Evaluation Event Manage Target
    ManageTarget.View Detail Evaluation Input
    ManageTarget.Show All Evaluatee In Manager Target