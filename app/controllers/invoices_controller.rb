class InvoicesController < ApplicationController
    def new
        @invoice = Invoice.new
        @check = Check.new
    end
    
    def create
        result = InvoiceService.new(params).call
    
        if result[:success]
          flash.now[:notice] = result[:message]
          @invoice = result[:invoices] # Ensure @invoice is set properly
          puts @invoice.inspect
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace("invoice_form", partial: "invoices/success", locals: { invoices: @invoice }) }
            format.html { redirect_to success_invoice_path(@invoice) }
          end
        else
          flash.now[:alert] = result[:message]
    
          # Initialize @invoice and @check to prevent NoMethodError
          @invoice = Invoice.new
          @check = Check.new
    
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace("invoice_form", partial: "invoices/form") }
            format.html { redirect_to new_invoice_path }
          end
        end
    end
end
