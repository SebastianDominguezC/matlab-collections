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

        function total = calcKineticEnergies(obj, N)
            bods = obj.bodies;
            total = zeros(1, N);

            for i = 1:length(bods)
                ke = bods(i).KERecord;

                for j = 1:N
                    total(j) = total(j) + ke(j);
                end

            end

        end

        function total = calcPotentialEnergies(obj, N)
            bods = obj.bodies;
            total = zeros(1, N);

            for i = 1:length(bods)
                bod = bods(i);
                copy = bods;
                copy([i]) = [];

                pe = bod.PotentialEnergy(copy, obj.G);

                for j = 1:N
                    total(j) = total(j) + pe(j);
                end

            end

            total = 0.5 * total;
        end

        function plotTotalEnergies(obj)
            N = length(obj.bodies(1).PositionRecord) - 1;
            KE = calcKineticEnergies(obj, N);
            PE = calcPotentialEnergies(obj, N);

            Tot = KE + PE;

            T = obj.t(1:N);
            figure;
            hold on;
            title('Grafico Energias');
            xlabel('t (t)');
            ylabel('E (J)');
            plot(T, KE, 'r');
            plot(T, PE, 'b');
            plot(T, Tot, 'g');
            legend('EK', 'EP', 'Tot');
        end

        function calcLinMomentum(obj)
            moments = obj.bodies(1).LinMRecord;
            bods = obj.bodies;
            N = length(bods);

            for i = 2:N
                body = bods(i);
                linMoment = body.LinMRecord;

                for j = 1:length(linMoment)
                    moments(j) = linMoment(j).Add(moments(j));
                end

            end

            % Magnitudes
            p = zeros(1, length(moments));

            for j = 1:length(moments)
                p(j) = moments(j).Magnitude;
            end

            T = obj.t(1:length(moments));

            figure;
            hold on;
            title('Grafico momento lineal');
            xlabel('t (t)');
            ylabel('Momentum (mv)');
            plot(T, p, 'r');
        end

    end

end
