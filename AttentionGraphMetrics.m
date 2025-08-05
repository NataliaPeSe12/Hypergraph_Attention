function AttentionGraphMetrics(G,nodes,x,y,Subject,FileName,path)
% Position nodes
    namesNodes = nodes;
    Subject = string(Subject);
    F_N = (strsplit(FileName,'_'));
    F_N = strcat(F_N(1),'_',F_N(2));
 % Centrality
    % Degree Centrality
    % if G.Edges.Weight(3) < 0
    %     G.Edges.Weight = abs(G.Edges.Weight);
    %     dc_g = centrality(G,'degree','Importance',G.Edges.Weight);
    %     edges_d = linspace(min(dc_g),max(dc_g),16);
    %     bins = discretize(dc_g,edges_d);
    %     p = figure('visible','off');
    %     plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
    %         'NodeFontSize',14,'MarkerSize',2*bins, 'NodeCData', dc_g);
    %     colormap autumn
    % else
    %     dc_g = centrality(G,'degree','Importance',G.Edges.Weight);
    %     edges_d = linspace(min(dc_g),max(dc_g),16);
    %     bins = discretize(dc_g,edges_d);
    %     p = figure('visible','off');
    %     plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
    %         'NodeFontSize',14,'MarkerSize',2*bins, 'NodeCData', dc_g);
    %     colormap summer
    % 
    % end
        dc_g = centrality(G,'outdegree');
        edges_d = linspace(min(dc_g),max(dc_g),16);
        bins = discretize(dc_g,edges_d);
        p = figure('visible','off');
        plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
            'NodeFontSize',14,'MarkerSize',2*bins, 'NodeCData', dc_g);
        colormap autumn
        colorbar
        title('Outdegree Centrality Scores')
        subtitle(strrep(F_N, '_', ' '))
        box off
        axis off
        f = '\Outdegree_Centrality_Graph_'+ Subject +'_'+F_N+'.jpg';
        f = path+f; 
        saveas(p,f)

        dc_g = centrality(G,'indegree');
        edges_d = linspace(min(dc_g),max(dc_g),16);
        bins = discretize(dc_g,edges_d);
        p = figure('visible','off');
        plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
            'NodeFontSize',14,'MarkerSize',2*bins, 'NodeCData', dc_g);
        colormap autumn
        colorbar
        title('Indegree Centrality Scores')
        subtitle(strrep(F_N, '_', ' '))
        box off
        axis off
        f = '\Indegree_Centrality_Graph_'+ Subject +'_'+F_N+'.jpg';
        f = path+f; 
        saveas(p,f)
    
    % Closeness Centrality
        G.Edges.Weight = abs(G.Edges.Weight);
        bc_g = centrality(G,'outcloseness','Cost',G.Edges.Weight);
        edges_Close = linspace(min(bc_g),max(bc_g),16);
        bins = discretize(bc_g,edges_Close);
        p = figure('visible','off');
        plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
            'NodeFontSize',14,'NodeCData', bc_g, 'MarkerSize', bins);
        colormap copper
        colorbar
        box off
        axis off
        title('Outcloseness Centrality Scores')
        subtitle(strrep(F_N, '_', ' '))
        f = '\Outcloseness_Centrality_'+ Subject +'_'+F_N+'.jpg';
        f = path+f; 
        saveas(p,f)

        G.Edges.Weight = abs(G.Edges.Weight);
        bc_g = centrality(G,'incloseness','Cost',G.Edges.Weight);
        edges_Close = linspace(min(bc_g),max(bc_g),16);
        bins = discretize(bc_g,edges_Close);
        p = figure('visible','off');
        plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
            'NodeFontSize',14,'NodeCData', bc_g, 'MarkerSize', bins);
        colormap copper
        colorbar
        box off
        axis off
        title('Incloseness Centrality Scores')
        subtitle(strrep(F_N, '_', ' '))
        f = '\Incloseness_Centrality_'+ Subject +'_'+F_N+'.jpg';
        f = path+f; 
        saveas(p,f)
    
    % % Eigenvector Centrality
    %     p = figure('visible','off');
    %     ec_g = centrality(G,'eigenvector','Importance',G.Edges.Weight);
    %     edges = linspace(min(ec_g),max(ec_g),8);
    %     bins = discretize(ec_g,edges);
    %     plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'LineWidth',1.5, ...
    %         'NodeFontSize',14,'NodeCData', ec_g, 'MarkerSize', bins);
    %     title('Eigenvector Centrality Scores - Weighted')
    %     colormap copper
    %     colorbar
    %     box off
    %     axis off
    %     f = '\Eigenvector_Centrality_'+ Subject +'_'+F_N+'.jpg';
    %     f = path+f; 
    %     saveas(p,f)
    
    % Connected graph components
        [bin,binsize] = conncomp(G);
        idx = binsize(bin) == max(binsize);
        c_g = subgraph(G, idx);
        p = figure('visible','off');
        plot(c_g)
        box off
        axis off
        title('Connected Graph Components')
        subtitle(strrep(F_N, '_', ' '))
        f = '\Connected_Components_'+ Subject +'_'+F_N+'.jpg';
        f = path+f; 
        saveas(p,f)
    
%     % Breadth-first graph search
%         figure
%         n1 = 2;
%         p = plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'EdgeLabel',V);
%         events = {'edgetonew','edgetofinished','startnode'};
%         b_g = bfsearch(G,n1,events,'Restart',true);
%         highlight(p, 'Edges', b_g.EdgeIndex(b_g.Event == 'edgetonew'), 'EdgeColor', 'g')
%         t = sprintf('Breadth-first Graph Search of %s',namesNodes{n1});
%         box off
%         axis off
%         title(t)
%         f = ['Breadth_first_search_' Subject '.jpg'];
%         f = [path f]; 
%         saveas(gcf,f)
    
%      % Shortestpath tree from node
%         n1 = 2;
%         spt_g = shortestpathtree(G,n1);
%         figure
%         plot(spt_g,'NodeLabel',namesNodes)
%         t = sprintf('Shortestpath tree from %s',namesNodes{n1});
%         box off
%         axis off
%         title(t)
%         f = ['Shortestpathtree_' Subject '.jpg'];
%         f = [path f]; 
%         saveas(gcf,f)

    % Shortest path distances of all node pairs
        dis_g = distances(G,'Method','unweighted');
        f = '\Distances_'+ Subject +'_'+F_N+'.txt';
        f = path+f; 
        writematrix(dis_g,f)
   
%     % Maximum flow in graph
%         figure
%         p = plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'EdgeLabel',G.Edges.Weight);
%         [mf_g,GF] = maxflow(G,1,6);
%         p.EdgeLabel = {};
%         highlight(p,GF,'EdgeColor','r','LineWidth',2);
%         st = GF.Edges.EndNodes;
%         box off
%         axis off
%         title('Maximum Flow')
%         f = ['Maximum_flow_' Subject '.jpg'];
%         f = [path f]; 
%         saveas(gcf,f)
    
%     % Minimum spanning tree of graph
%         figure
%         p = plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'EdgeLabel',G.Edges.Weight);
%         [T,pred] = minspantree(G);
%         highlight(p,T)
%         title('Minimum Spanning Tree')
%         box off
%         axis off
%         f = ['Minimum_Spanning_' Fr '.jpg'];
%         f = [path f]; 
%         saveas(gcf,f)
    
    % Cycles
        % Determine whether graph contains cycles
        % has_cyc = hascycles(G); % logical value
        % % Find all cycles in graph
        % c1 = 1;
        % if has_cyc == 1
        %     figure
        %     p = plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes);
        %     [cycles, edgecycles] = cyclebasis(G);
        %     ct = size(cycles,1);
        %     highlight(p,cycles{c1},'Edges',edgecycles{c1},'EdgeColor','r','LineWidth',1.5,'NodeColor','r','MarkerSize',6)
        %     t = sprintf('Cycle number %d of %d',c1,ct);
        %     box off
        %     axis off
        %     title(t)
        %     f = '\Cycles_'+ Subject +'_'+F_N+'.jpg';
        %     f = path+f; 
        %     saveas(p,f)
        % else
        % end

    % % Degree of graph nodes
    %     d_g = degree(G);
    %     f = '\Degree_'+ Subject +'_'+F_N+'.txt';
    %     f = path+f; 
    %     writematrix(d_g,f)
    
%     % Nearest neighbors within radius
%         figure
%         Dis = 5;
%         Nod = 1;
%         p = plot(G,'XData',x,'YData',y,'NodeLabel',namesNodes,'EdgeLabel',G.Edges.Weight);
%         nn_g = nearest(G,Nod,Dis);
%         highlight(p,1,'NodeColor','g')
%         highlight(p,nn_g,'NodeColor','r')
%         box off
%         axis off
%         t = sprintf('Nearest neighbors of distance %d to %s',Dis,namesNodes{Nod});
%         title(t)
%         f = ['Nearest_neighbors_' Subject '.jpg'];
%         f = [path f]; 
%         saveas(gcf,f)
end