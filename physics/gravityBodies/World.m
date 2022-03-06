classdef World

    properties
        bodies
        G
        t
        dt
    end

    methods

        function w = World(g, bodies, t, dt)
            w.G = g;
            w.bodies = bodies;
            w.t = t;
            w.dt = dt;
        end

        function test(obj)
            body1 = obj.bodies(1);
            body2 = obj.bodies(2);
            disp(body1.Position.Magnitude);
            disp(body2.Position.Magnitude);

            disp(body1.DirToOther(body2));
            disp(body2.DirToOther(body1));

            disp("Acc");
            disp(body1.Acc(body2, obj.G));
            disp(body2.Acc(body1, obj.G));

            disp("F");
            disp(body1.Acc(body2, obj.G).Magnitude * body1.Mass);
            disp(body2.Acc(body1, obj.G).Magnitude * body2.Mass);

        end

        function plot(obj)
            bods = obj.bodies;
            figure;
            title('Objectos');
            hold on;
            grid on;
            view(3);

            for i = 1:length(bods)
                p = bods(i).Position;
                x = p.x;
                y = p.y;
                z = p.z;
                plot3(x, y, z, '*');
            end

            hold off;
        end

        function simulate(obj)
            N = length(obj.t);
            bods = obj.bodies;
            % Leapfrog on every body
            for i = 1:N
                exit = false;

                % Update positions
                for j = 1:length(bods)
                    bod = bods(j);
                    copy = bods;
                    copy([j]) = [];
                    net_acc = bod.NetAcc(copy, obj.G);

                    bod.VHalfStep(net_acc, obj.dt);
                    bod.PosStep(obj.dt);

                    new_net_acc = bod.NetAcc(copy, obj.G);
                    bod.VFullStep(new_net_acc, obj.dt);
                end

                % Check Collisions
                for j = 1:length(bods)
                    bod = bods(j);
                    copy = bods;
                    copy([j]) = [];

                    for k = 1:length(copy)

                        if (bod.DetectCollision(copy(k)))
                            exit = true;
                        end

                    end

                end

                if (exit)
                    disp('collision detected');
                    break;
                end

            end

        end

        function plotTrayectories(obj)
            bods = obj.bodies;
            figure;
            title('Objectos');
            hold on;
            grid on;
            view(3);

            for i = 1:length(bods)
                positions = bods(i).PositionRecord;
                L = length(positions);
                x = zeros(1, L);
                y = zeros(1, L);
                z = zeros(1, L);

                for j = 1:L
                    x(j) = positions(j).x;
                    y(j) = positions(j).y;
                    z(j) = positions(j).z;
                end

                plot3(x, y, z, bods(i).Color);
            end

            hold off;
        end

    end

end
