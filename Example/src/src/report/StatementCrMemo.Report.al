//    This report uses the same layout as the Statement Invoice report.
report 5266008 "lbt com Statement Cr.Memo"
{

    Caption = 'Commission Clawback';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;

    RDLCLayout = 'src/report/CommissionStatement.rdlc';
    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {

            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Cr.Memos';

            column(CommissionSettlementCaption; CommissionStatementCaptionLbl) { }
            column(CompInfoHeader1; CompInfoHeader1) { }
            column(CompInfoHeader2; CompInfoHeader2) { }
            column(CommissionAmountCaption; CommissionAmountCaptionLbl) { }
            column(CommissionRateCaption; CommissionRateCaptionLbl) { }
            column(InvoiceAmountCaption; InvoiceAmountCaptionLbl) { }
            column(DebtSettledCaption; DebtSettledCaptionLbl) { }
            column(InvoiceNoOrderNoCaption; InvoiceNoOrderNoCaptionLbl) { }
            column(NoOfCopies; NoOfCopies) { }
            column(OfCaption; OfCaptionLbl) { }
            column(PageCaption; PageCaptionLbl) { }
            column(BranchName; BranchNameTxt) { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(PricesIncludingVAT_PurchInvHeader; "Purch. Cr. Memo Hdr."."Prices Including VAT") { }
            column(CurrencyCode; CurrencyCodeTxt) { }
            column(TotalText; TotalAmountCaptionLbl) { }
            column(TotalExclVATText; TotalExclVatCaptionLbl) { }
            column(TotalInclVATText; TotalInclVatCaptionLbl) { }
            column(BankInfo; StrSubstNo(BankInfoTemplateTxt, CompanyInfo."Bank Name", CompanyInfo."Bank Branch No.", CompanyInfo."Bank Account No.", CompanyInfo.IBAN)) { }
            column(AllocInfo1; StrSubstNo(AllocInfo1TemplateTxt, AllocationCompanyRec."Phone No.", AllocationCompanyRec."Fax No.", AllocationCompanyRec."E-Mail", AllocationCompanyRec."Home Page")) { }
            column(AllocInfo2; StrSubstNo(AllocInfo2TemplateTxt, AllocationCompanyRec.Name, AllocationCompanyRec.Address, AllocationCompanyRec."Address 2", AllocationCompanyRec."Post Code", AllocationCompanyRec.City)) { }
            column(PurchInvHeader_No; "Purch. Cr. Memo Hdr."."No.") { }
            column(CommissionStatementCaption; CommissionStatementCaptionLbl) { }
            column(SalesPurchPerson__E_Mail_; SalesPurchPerson."E-Mail") { }
            column(EmailCaption; EmailCaptionLbl) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(Period; Period) { }
            column(ContractText; StrSubstNo(ReceiveCommissionTxt, Period)) { }
            column(ContactAnrede; ContactAnrede) { }
            column(DateCaption; DateCaptionLbl) { }
            column(PurchInvHeader_DocDate; "Purch. Cr. Memo Hdr."."Document Date") { }
            column(SalesPurchPerson__Phone_No__; SalesPurchPerson."Phone No.") { }
            column(SalesPurchPerson_Name; SalesPurchPerson.Name) { }
            column(PhoneCaption; TelephoneCaptionLbl) { }
            column(YourContactCaption; YourContactCaptionLbl) { }
            column(YourVatNoCaption; YourVatNoCaptionLbl) { }
            column(BuyFromVendorNo; "Purch. Cr. Memo Hdr."."Buy-from Vendor No.") { }
            column(Vendor_VarRegNo; Vendor."VAT Registration No.") { }
            column(VendorIdCaption; VendorIdCaptionLbl) { }
            column(VendAddr_8_; VendAddr[8]) { }
            column(VendAddr_7_; VendAddr[7]) { }
            column(VendAddr_6_; VendAddr[6]) { }
            column(VendAddr_5_; VendAddr[5]) { }
            column(VendAddr_4_; VendAddr[4]) { }
            column(VendAddr_3_; VendAddr[3]) { }
            column(VendAddr_2_; VendAddr[2]) { }
            column(VendAddr_1_; VendAddr[1]) { }
            column(CompanyInfo_PostCode_City; CompanyInfo."Post Code" + ' ' + CompanyInfo.City) { }
            column(CompanyInfo_Address; CompanyInfo.Address) { }
            column(CompInfo_FaxNo; StrSubstNo(FaxNoTemplateTxt, CompanyInfo."Fax No.")) { }
            column(CompInfo_TaxNo; StrSubstNo(TaxNoTemplateTxt, CompanyInfo."Registration No.")) { }
            column(CompInfo_PhoneNo; StrSubstNo(PhoneNoTemplateTxt, CompanyInfo."Phone No.")) { }
            column(CompInfo_VatNo; StrSubstNo(VATNoTemplateTxt, CompanyInfo."VAT Registration No.")) { }
            column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail") { }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(OutputNo; OutputNo) { }


                dataitem(DimensionLoop1; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    DataItemLinkReference = "Purch. Cr. Memo Hdr.";

                    column(DimText; DimText) { }
                    column(Header_DimensionsCaption; Header_DimensionsCaptionLbl) { }
                    column(DimensionLoop1_Number; Number) { }
                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo2 then
                            CurrReport.Break();
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not DimSetEntry1.FindSet() then
                                CurrReport.Break();

                        end else
                            if not Continue then
                                CurrReport.Break();

                        Clear(DimText);
                        Continue := false;

                        repeat
                            OldDimText := DimText;
                            if DimText = '' then
                                DimText := StrSubstNo(DimTemplateTxt, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                            else
                                DimText :=
                                  StrSubstNo(
                                    CombinedDimTemplateTxt, DimText,
                                    DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                            if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                            end;
                        until DimSetEntry1.Next() = 0;
                    end;


                }

                dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.");
                    DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                    DataItemLink = "Document No." = field("No.");
                    column(PrintOptionNo; PrintOptionNo) { }
                    column(TypeNo; TypeNo.AsInteger()) { }
                    column(Line_Description; Description) { }
                    column(Line_Description2; "Description 2") { }
                    column(Line_Description_Description2; StrSubstNo(SlashTemplateTxt, Description, "Description 2")) { }
                    column(Line_ExpectedReceiptDate; "Expected Receipt Date") { }
                    column(Line_InvoiceAmount; "Direct Unit Cost") { }
                    //column(STRSUBSTNO___1__2__Format(_Purch__Inv__Line___Direct_Unit_Cost_Price_Factor____100_0___Sign__Integer__Decimals_3________; STRSUBSTNO('%1 %2', Format("Purch. Cr. Memo Line"."Direct Unit Cost Price Factor" * 100, 0, '<Sign><Integer><Decimals,3>'), '%')) { }
                    column(Line_CommissionRate; Quantity) { }
                    column(Line_Amount; Amount)
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = "Purch. Cr. Memo Line".GetCurrencyCode();
                    }
                    column(Commission_amount_brought_forwardCaption; Commission_amount_brought_forwardCaptionLbl) { }
                    column(Subtotal_commission_amoutCaption; Subtotal_commission_amoutCaptionLbl) { }
                    column(Line_LineNo; "Line No.") { }

                    trigger OnPreDataItem()
                    begin
                        TempVATAmountLine.DeleteAll();
                        ;
                        MoreLines := Find('+');
                        while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                            MoreLines := Next(-1) <> 0;
                        if not MoreLines then
                            CurrReport.Break();
                        SetRange("Line No.", 0, "Line No.");

                        //CurrReport.CREATETOTALS("Line Amount", "Inv. Discount Amount", Amount, "Amount Including VAT"); //TODO:

                        TTLineAmount := 0;
                        TTAmount := 0;
                        TTInvDiscountAmount := 0;
                        TTAmountIncludingVat := 0;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        VATPostingSetup: Record "VAT Posting Setup";
                    begin
                        if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                            "No." := '';

                        TypeNo := Type;
                        // PrintOptionNo := "Purch. Cr. Memo Line".Printoption;

                        TempVATAmountLine.Init();
                        TempVATAmountLine."VAT Identifier" := "Purch. Cr. Memo Line"."VAT Identifier";
                        TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        TempVATAmountLine."Tax Group Code" := "Tax Group Code";
                        TempVATAmountLine."Use Tax" := "Use Tax";
                        TempVATAmountLine."VAT %" := "VAT %";
                        TempVATAmountLine."VAT Base" := Amount;
                        TempVATAmountLine."Amount Including VAT" := "Amount Including VAT";
                        TempVATAmountLine."Line Amount" := "Line Amount";
                        if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                            TempVATAmountLine."VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                        if "Allow Invoice Disc." then
                            TempVATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                        TempVATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                        TempVATAmountLine.InsertLine();

                        TTLineAmount += "Line Amount";
                        TTAmount += Amount;
                        TTInvDiscountAmount += "Inv. Discount Amount";
                        TTAmountIncludingVat += "Amount Including VAT";
                    end;
                }
                dataitem(VATClauseEntryCounter; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(VATClauseVATAmtCaption; VATAmountCaptionLbl) { }
                    column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl) { }
                    column(VATClausesCaption; VATClausesCaptionLbl) { }
                    column(VATClauseVATIdentifier; TempVATAmountLine."VAT Identifier") { }
                    column(VATClauseDescription; VATClause.Description) { }
                    column(VATClauseDescription2; VATClause."Description 2") { }
                    column(VATClauseAmount; TempVATAmountLine."VAT Amount") { }
                    column(VATClauseCode; TempVATAmountLine."VAT Clause Code") { }

                    trigger OnPreDataItem()
                    begin
                        Clear(VATClause);
                        SetRange(Number, 1, TempVATAmountLine.Count());
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.GetLine(Number);
                        if not VATClause.Get(TempVATAmountLine."VAT Clause Code") then
                            CurrReport.Skip();
                        VATClause.TranslateDescription("Purch. Cr. Memo Hdr."."Language Code");
                    end;
                }
                dataitem(DimensionLoop2; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                    column(DimensionLoop2_DimText; DimText) { }
                    column(Line_DimensionsCaption; Line_DimensionsCaptionLbl) { }
                    column(DimensionLoop2_Number; Number) { }

                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo then
                            CurrReport.Break();
                    end;
                }

                dataitem(Total; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(TTAmount; TTAmount) { }
                    column(TTInvDiscountAmount; TTInvDiscountAmount) { }
                    column(TTLineAmount; TTLineAmount) { }
                    column(TTAmountIncludingVat; TTAmountIncludingVat) { }
                    column(VATAmountLine_VATAmountText; TempVATAmountLine.VATAmountText()) { }

                }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1));
                    MaxIteration = 1;
                    trigger OnPostDataItem()
                    begin
                        //TODO:
                        //     if CurrReport.PAGENO <> 1 then
                        //         Pagetext := Text008
                        //     else
                        //         Pagetext := '';
                    end;
                }

                dataitem("Extended Text Header"; "Extended Text Header")
                {
                    DataItemTableView = sorting("Table Name", "No.", "Language Code", "Text No.") order(ascending) where("Table Name" = const("Standard Text"));
                    dataitem("Extended Text Line"; "Extended Text Line")
                    {
                        DataItemLink = "No." = field("No."), "Text No." = field("Text No."), "Language Code" = field("Language Code");
                        DataItemTableView = sorting("Table Name", "No.", "Language Code", "Text No.", "Line No.") order(ascending);
                        column(TextLine; TextLine) { }

                        trigger OnAfterGetRecord()
                        begin
                            TextLine := StrSubstNo("Extended Text Line".Text,
                                                        VendorBankAccountRec.IBAN,
                                                        VendorBankAccountRec.Name,
                                                        VendorBankAccountRec."SWIFT Code");
                        end;
                    }
                    trigger OnPreDataItem()
                    begin
                        SetFilter("Starting Date", '%1|<=%2', 0D, Today);
                        SetFilter("Ending Date", '%1|>=%2', 0D, Today);
                        SetRange("Language Code", "Purch. Cr. Memo Hdr."."Language Code");
                        if IsEmpty then begin
                            SetRange("Language Code");
                            SetRange("All Language Codes", true);
                        end;
                    end;

                }

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then
                        CopyText := CopyCaptionLbl;
                    OutputNo += 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview() then
                        PurchCrMemoPrinted.Run("Purch. Cr. Memo Hdr.");
                end;
            }

            trigger OnAfterGetRecord()
            var
                VendRec: Record Vendor;
                FormatDocument: Codeunit "Format Document";
                Language: Codeunit Language;
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");
                GetCompanyInfo();

                Pagetext := PageFollowsCaptionLbl;
                DimSetEntry1.Reset();
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                SetPeriod();

                AllocationCompanyRec.Get();

                SetHeaderAnschrift();

                BranchNameTxt := AllocationCompanyRec.Name;
                if BranchNameTxt = CompanyInfo.Name then
                    BranchNameTxt := '';

                //if "Contact Bank" <> '' then begin //TODO:
                //  VendorBankAccountRec.Get("Buy-from Vendor No.","Contact Bank");
                VendRec.Get("Purch. Cr. Memo Hdr."."Pay-to Vendor No.");
                // VendRec.TestField("Preferred Bank Account Code");
                if VendRec."Preferred Bank Account Code" <> '' then
                    VendorBankAccountRec.Get("Buy-from Vendor No.", VendRec."Preferred Bank Account Code");

                //end;
                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                FormatDocument.SetSalesPerson(SalesPurchPerson, "Purchaser Code", SalesPersonText);

                CurrencyCodeTxt := "Currency Code";
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyCodeTxt := GLSetup."LCY Code";
                end;
                FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
                FormatAddr.PurchCrMemoPayTo(VendAddr, "Purch. Cr. Memo Hdr.");
                FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");

                FormatAddr.PurchCrMemoShipTo(ShipToAddr, "Purch. Cr. Memo Hdr.");

                if Vendor.Get("Purch. Cr. Memo Hdr."."Buy-from Vendor No.") then;  //für Vat Reg.Nr.

                SetSalutation();

                if LogInteraction then
                    if not CurrReport.Preview() then
                        SegManagement.LogDocument(
                          14, "No.", 0, 0, Database::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
            end;

        }


    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'DEU="Optionen"';

                    field(NumberOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;

                        Caption = 'Number of Copies', Comment = 'DEU="Anzahl Kopien"';
                        ToolTip = 'Specifies the value of the Number of Copies field', Comment = 'DEU="Anzahl Kopien"';
                    }
                    field("Internal Information"; ShowInternalInfo2)
                    {
                        ApplicationArea = All;
                        Caption = 'Internal Information', Comment = 'DEU="Interne Informationen"';
                        ToolTip = 'Specifies the value of the Internal Information field', Comment = 'DEU="Interne Informationen"';
                    }
                    field("Hide Company Information"; HideCompanyInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Hide Company Information', Comment = 'DEU="Firmendaten ausblenden"';
                        ToolTip = 'Specifies the value of the Hide Company Information field', Comment = 'DEU="Firmendaten ausblenden"';
                    }
                    field("Log Interaction"; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction', Comment = 'DEU="Aktivität protokollieren"';
                        ToolTip = 'Specifies the value of the Log Interaction field', Comment = 'DEU="Aktivität protokollieren"';
                    }
                }
            }
        }


    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
    end;

    local procedure SetPeriod()
    begin
        SetPeriodMonthly();
    end;

    local procedure GetOrdinalText(PeriodNo: Text): Text
    begin
        case PeriodNo of
            '1':
                exit(OrdinalStTxt);
            '2':
                exit(OrdinalNdTxt);
            '3':
                exit(OrdinalRdTxt);
            '4':
                exit(OrdinalThTxt);
        end;
    end;

    local procedure SetPeriodMonthly()
    begin
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period Start", 0D, "Purch. Cr. Memo Hdr."."Posting Date");
        if DateRec.FindLast() then
            Period := DateRec."Period Name" + ' ' + Format(Date2DMY("Purch. Cr. Memo Hdr."."Posting Date", 3));
    end;

    local procedure SetPeriodQuarterly()
    begin
        DateRec.Reset();
        DateRec.SetRange("Period Type", DateRec."Period Type"::Quarter);
        DateRec.SetRange("Period Start", 0D, "Purch. Cr. Memo Hdr."."Posting Date");
        if DateRec.FindLast() then
            Period := Format(DateRec."Period No.") + GetOrdinalText(Format(DateRec."Period No.")) + QuarterCaptionLbl;
        Period := Period + ' ' + Format(Date2DMY("Purch. Cr. Memo Hdr."."Posting Date", 3));
    end;

    local procedure SetPeriodBiannually()
    begin
        if Date2DMY("Purch. Cr. Memo Hdr."."Posting Date", 2) <= 6 then
            Period := '1'
        else
            Period := '2';
        Period := Period + GetOrdinalText(Period) + HalfYearCaptionLbl;
        Period := Period + ' ' + Format(Date2DMY("Purch. Cr. Memo Hdr."."Posting Date", 3));
    end;

    local procedure GetCompanyInfo()
    begin
        CompInfoHeader1 := '';
        CompInfoHeader2 := '';
        CompInfoHeader3 := '';
        if HideCompanyInfo then
            exit;
        CompanyInfo.Get();

        CompanyInfo.CalcFields(Picture);

        CompInfoHeader1 := StrSubstNo(CompInfoHeader1TemplateTxt, AllocationCompanyRec.Name, HeaderanschriftText,
                                     AllocationCompanyRec."Post Code", AllocationCompanyRec.City);
        CompInfoHeader2 := StrSubstNo(CompInfoHeader2TemplateTxt, AllocationCompanyRec."Phone No.", AllocationCompanyRec."Fax No.");
        CompInfoHeader3 := StrSubstNo(CompInfoHeader3TemplateTxt, CompanyInfo.Name, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City);
    end;

    local procedure SetHeaderAnschrift()
    begin
        HeaderanschriftText := AllocationCompanyRec.Address;
        HeaderanschriftText2 := AllocationCompanyRec.Address;
        if (AllocationCompanyRec.Address <> '') and (AllocationCompanyRec."Address 2" <> '') then begin
            HeaderanschriftText += ' · ';
            HeaderanschriftText2 += ', ';
        end;
        HeaderanschriftText += AllocationCompanyRec."Address 2";
        HeaderanschriftText2 += AllocationCompanyRec."Address 2";
    end;

    local procedure SetSalutation()
    begin
        if Vendor."Primary Contact No." <> '' then
            if ContRec.Get(Vendor."Primary Contact No.") then
                ContactAnrede := ContRec.GetSalutation(Enum::"Salutation Formula Salutation Type"::Formal, "Purch. Cr. Memo Hdr."."Language Code") + ',';
        if ContactAnrede = '' then
            ContactAnrede := SalutationTxt;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        Vendor: Record Vendor;
        AllocationCompanyRec: Record "Company Information";
        VendorBankAccountRec: Record "Vendor Bank Account";
        ContRec: Record Contact;
        DimSetEntry1: Record "Dimension Set Entry";
        DateRec: Record Date;
        VATClause: Record "VAT Clause";
        PurchCrMemoPrinted: Codeunit "PurchCrMemo-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text;
        ShipToAddr: array[8] of Text;
        CompanyAddr: array[8] of Text;
        CopyText: Text;
        DimText: Text;
        OldDimText: Text;
        HeaderanschriftText: Text;
        HeaderanschriftText2: Text;
        Pagetext: Text;
        Period: Text;
        CurrencyCodeTxt: Text;
        BranchNameTxt: Text;
        ContactAnrede: Text;
        CompInfoHeader1: Text;
        CompInfoHeader2: Text;
        CompInfoHeader3: Text;
        TextLine: Text;
        TTLineAmount: Decimal;
        TTAmount: Decimal;
        TTInvDiscountAmount: Decimal;
        TTAmountIncludingVat: Decimal;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        TypeNo: Enum "Purchase Document Type";
        PrintOptionNo: Integer;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean; // INDATASET;
        Continue: Boolean;
        LogInteraction: Boolean;
        HideCompanyInfo: Boolean;
        ShowInternalInfo2: Boolean; // INDATASET;

        TotalAmountCaptionLbl: Label 'Total amount', Comment = 'DEU="Provisionsbetrag"';
        TotalInclVatCaptionLbl: Label 'Total Incl. VAT', Comment = 'DEU="Total inkl. MwSt."';
        CopyCaptionLbl: Label 'COPY', Comment = 'DEU="KOPIE"';
        TotalExclVatCaptionLbl: Label 'Total Excl. VAT', Comment = 'DEU="Total ohne MwSt."';
        PageFollowsCaptionLbl: Label 'Page %1/Page follows', Comment = 'DEU="Seite %1/Seite folgt"';
        EmailCaptionLbl: Label 'E-Mail:', Comment = 'DEU="E-Mail:"';
        YourContactCaptionLbl: Label 'Your contact:', Comment = 'DEU="Sachbearbeiter:"';
        VendorIdCaptionLbl: Label 'Creditor ID:', Comment = 'DEU="Kreditoren-Nr.:"';
        YourVatNoCaptionLbl: Label 'Your VAT no.:', Comment = 'DEU="Ihre USt.-IdNr.:"';
        DateCaptionLbl: Label 'Date:', Comment = 'DEU="Datum:"';
        TelephoneCaptionLbl: Label 'Telephone:', Comment = 'DEU="Telefon:"';
        SalutationTxt: Label 'Dear Sir or Madam,', Comment = 'DEU="Sehr geehrte Damen und Herren,"';
        ReceiveCommissionTxt: Label 'for the deliveries of the accounting period %1 you will receive your contractual commission.', Comment = 'DEU="für den Abrechnungszeitraum %1 erhalten Sie vertragsgemäß Ihre Provision."';
        CommissionStatementCaptionLbl: Label 'Commission clawback:', Comment = 'DEU="Provisionsrückforderung:"';
        QuarterCaptionLbl: Label ' quarter', Comment = 'DEU="" Quartal';
        HalfYearCaptionLbl: Label ' half-year', Comment = 'DEU="" Halbjahr';
        OrdinalStTxt: Label 'st', Comment = 'DEU="."';
        OrdinalNdTxt: Label 'nd', Comment = 'DEU="."';
        OrdinalRdTxt: Label 'rd', Comment = 'DEU="."';
        OrdinalThTxt: Label 'th', Comment = 'DEU="."';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions', Comment = 'DEU="Kopfdimensionen"';
        InvoiceNoOrderNoCaptionLbl: Label 'Description/Document No.', Comment = 'DEU="Bezeichnung/Beleg-Nr."';
        CommissionAmountCaptionLbl: Label 'Commission amount', Comment = 'DEU="Provision"';
        DebtSettledCaptionLbl: Label 'Debt. settled', Comment = 'DEU="Ausgeglichen am"';
        InvoiceAmountCaptionLbl: Label 'Amount', Comment = 'DEU="Betrag"';
        CommissionRateCaptionLbl: Label 'Commission rate', Comment = 'DEU="Provisionssatz"';
        Commission_amount_brought_forwardCaptionLbl: Label 'Commission amount brought forward', Comment = 'DEU="Übertrag Provisionsbetrag"';
        Subtotal_commission_amoutCaptionLbl: Label 'Subtotal commission amout', Comment = 'DEU="Zwischensumme Provisionsbetrag"';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions', Comment = 'DEU="Zeilendimensionen"';
        PageCaptionLbl: Label 'Page', Comment = 'DEU="Seite"';
        OfCaptionLbl: Label 'of', Comment = 'DEU="von"';
        VATNoTemplateTxt: Label 'VAT no.: %1', Comment = 'DEU="USt.-IdNr.: %1"';
        TaxNoTemplateTxt: Label 'Tax no.: %1', Comment = 'DEU="Steuer-Nr.: %1"';
        VATAmountCaptionLbl: Label 'VAT Amount', Comment = 'DEU="MwSt.-Betrag"';
        VATIdentifierCaptionLbl: Label 'VAT Identifier', comment = 'DEU="MwSt.-Kennzeichen"';
        VATClausesCaptionLbl: Label 'VAT Clause', comment = 'DEU="MwSt.-Klausel"';
        BankInfoTemplateTxt: Label 'Bankverbindung: %1, BLZ %2, Kto-Nr.: %3, IBAN: %4', Locked = true;
        AllocInfo1TemplateTxt: Label 'Telefon: %1, Telefax: %2, e-mail: %3, Internet: %4', Locked = true;
        AllocInfo2TemplateTxt: Label '%1, %2, %3, %4 %5', Locked = true;
        FaxNoTemplateTxt: Label 'Fax.: %1', Locked = true;
        PhoneNoTemplateTxt: Label 'Tel.: %1', Locked = true;
        DimTemplateTxt: Label '%1 %2', Locked = true;
        CombinedDimTemplateTxt: Label '%1, %2 %3', Locked = true;
        SlashTemplateTxt: Label '%1/%2', Locked = true;
        CompInfoHeader1TemplateTxt: Label '%1 · %2 · %3 %4', Locked = true;
        CompInfoHeader2TemplateTxt: Label 'Telefon %1 · Telefax %2', Locked = true;
        CompInfoHeader3TemplateTxt: Label '%1, %2, %3 %4', Locked = true;
        SalesPersonText: Text[50];
}