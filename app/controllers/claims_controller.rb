class ClaimsController < ApplicationController
    
    before_action :authenticate_user!
    def index
        @claims = Claim.where(parent_id:0)
    end

    def new
        @claim = Claim.new
    end
    def create
        claim = Claim.new(claim_params)
        claim.user_id = current_user.id
        if claim.save
            redirect_to :action => "index"
        else
            redirect_to :action => "new"
        end
    end

    def findChildren(nodeid)
        logger.debug('-------------------------------------------')
        if Claim.exists?(parent_id:nodeid)
            @claimNChildren = Claim.where(parent_id:nodeid)
            @claimNChildren.each do |c|
                @@nodes.push({"id" => c.id,"title" => c.title,"size" => c.likes.count,"group" => 1})
                @@links.push({"source" => nodeid, "target" => c.id, "lineWidth" => 1})
                findChildren(c.id)
            end
        end
    end



    def show
        @claim = Claim.find(params[:id])
        # @@claim = @claim

        @parent_claims = Claim.where(id:@claim.parent_id)
        @child_claims = Claim.where(parent_id:@claim.id)

        logger.debug(Claim.exists?(parent_id:@claim.id))
        @question = Question.new
        @questions = @claim.questions

        @child_claim = Claim.new

        # @nodes_array = [{"id" => @claim.id,"title" => @claim.title, "group" => 0}]

        # firstClaimId = @claim.id
        # claimN = @claim
        # claimNChildrenArray = []
        @@nodes = []
        @@links = []
        @@nodes.push({"id" => @claim.id,"title" => @claim.title,"size" => @claim.likes.count,"group" => 0})
        findChildren(@claim.id)
        # while Claim.exists?(parent_id:claimN.id) do
        #     @claimNChildren = Claim.where(parent_id:claimN.id)
        #     @claimNChildren.each do |c|
        #         @nodes_array.push({"id" => c.id,"title" => c.title,"group" => 1})
        #         claimNChildrenArray.push(c)
        #         claimNChildrenArray.each do |d|

        #     end
        #     # logger.debug(claimNChildrenArray)
                

        #     break
        # end

        # @child_claims.each do |c|
        #     @nodes_array.push({"id" => c.id,"title" => c.title,"group" => 1})
        # end

        # @@nodes = @nodes_array
        logger.debug(@@nodes)
        


    end

    def edit
        @claim = Claim.find(params[:id])
    end

    def update
        claim = Claim.find(params[:id])
        if claim.update(claim_params)
            redirect_to :action => "show", :id => claim.id
        else
            redirect_to :action => "new"
        end
    end

    def destroy
        claim = Claim.find(params[:id])
        claim.destroy
        redirect_to action: :index
    end

    def list  
        # nodes_pass = @@nodes
        data = {
            "nodes": @@nodes,

            # [
            # {"id": "Myriel", "group": 1},
            # {"id": "Napoleon", "group": 1},
            # {"id": "Mlle.Baptistine", "group": 1},
            # {"id": "Mme.Magloire", "group": 1},
            # {"id": "CountessdeLo", "group": 1},
            # {"id": "Geborand", "group": 1},
            # ]

            "links": @@links
            # [
                # {"source": 1, "target":2, "lineWidth": 1},
                #  {"source": 1, "target":2, "value": 1},
                # {"source": "Napoleon", "target": "Mlle.Baptistine", "value": 1},
                # {"source": "Napoleon", "target": "Mme.Magloire", "value": 1},
                # {"source": "Mlle.Baptistine", "target": "CountessdeLo", "value": 1},
                # {"source": "Mlle.Baptistine", "target": "Geborand", "value": 1},
                # {"source": "Mme.Magloire", "target": "Count", "value": 1},
                # {"source": @@claim.title, "target": "Cravatte", "value": 1},
            # ]
        } 

        render :json => data
    end

    private
    def claim_params
        params.require(:claim).permit(:title,:id,:parent_id)
    end
end
